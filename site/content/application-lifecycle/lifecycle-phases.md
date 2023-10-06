---
title: "Lifecycle Phases"
layout: "docs"
weight: 2
---

Let's take a deeper look at application lifecycle events in Cloud Foundry.

## Pushing

`cf push` consists of three stages: upload, staging and starting. For each of these stages `cf push` is the initiator.

For the CFCD exam, you don't need to know in detail what happens under the hood, but it's useful to have a high-level understanding. If a lot of this section goes over your head, that's OK. You don't need to memorize these steps, and we'll be revisiting the `cf push` procedure in the advanced section of this course when we look at sub-step commands. Equally, if you'd like a more detailed explanation, have a read of the [documentation](https://docs.cloudfoundry.org/concepts/how-applications-are-staged.html)

The next few paragraphs describe the sequence of events after a developer runs `cf push` against their app code.

### 1. Uploading

1. A record is created for the app.
2. App metadata, including the name, the desired number of instances, selected buildpack, are stored in a database called the Cloud Controller Database (CCDB).
3. Source files are uploaded. Any app files that already exist in the resource cache are omitted.
4. The uploaded app files are combined with any already in the resource cache to create the app package.
5. The app package is stored.

### 2. Staging

At this point, the CLI issues a request to start the app, but before the app can be started it needs to be staged. Staging is the process of creating the containerized image for your application.

* The buildpack is selected to stage the app (if not specified).
* A droplet (tarball) containing the compiled and staged app is created by the buildpack and stored. The droplet is the container image for your application minus the root file system. 
* The buildpack cache is updated so that it can be used the next time the app is staged.
* The staging phase is complete.

### 3. Starting

1. The containerized app is scheduled as a long-running process. 
2. The app is up and running once it passes a health check.

In the advanced section of this course, we'll take a look at using sub-step commands to take more granular control over each of the above steps.

## Restarting, Restaging, and Re-pushing

In some instances, you'll need to make changes to a running application. For example, you might want to roll out an update to your application code, or respond to a crashing app.

In such cases, you'll often use `restart`, `restage`, or (re)-`push` to make your changes.

### `--strategy rolling`

The --strategy flag was introduced with v3 of the Cloud Foundry API to enable rolling (zero downtime) deployments, and it is currently the only strategy available, meaning that the strategy flag can either be set to `rolling` or null.

We'll speak a bit about the context of rolling deployments and compare them to the earlier mechanism of Blue-Green deployments over the next couple of sections. For now, it's just worth noting that the --strategy flag enables zero-downtime app updates, and can be used when `restarting`, `restaging`, or re-`pushing`.

### Restarting

Restarting is the least disruptive of the three operations. When restarting an app, Cloud Foundry will destroy existing running container instances and create new ones. The existing droplet and config are used when creating the new instances. Restarting an application can be useful when the droplet content hasn't changed, but you want the application processes to be restarted.

> If you run `cf restart` without `--strategy rolling` your app will experience downtime. We will look at this more in the next section.

### Restarting a Single Instance

It's also possible to restart a specific instance of your application. If you wanted to, you could manually restart application instances one at a time to update your application without downtime (as long as you have more than one), but `--strategy rolling` does this more efficiently as you will see in the next section.

Individual application instances are restarted by providing the instance index number. This can be retrieved by running `cf app training-app` and always starts at 0.

```
cf restart-app-instance training-app 0
```

A better use case for an instance restart is after a user has accessed it via ssh. Let's look at why.

> `cf ssh` will be covered in more detail in the troubleshooting section. This is just for demonstration purposes.

```
cf ssh training-app -i 0
```

Then inside the container session run:

```
rm -fr app
exit
```

`rm -fr app` will recursively delete the app directory. It's unlikely that you would normally do this, but changes made by a user on an app instance can have ramifications for end users. If you were to try and open the `training-app` in your browser now, responses served by instance `0` would fail.

If you change something unintentionally when accessing a container via ssh, you can use restart to destroy the container instance you accessed and get a fresh one.

### Restaging

When you restage an app, you are asking Cloud Foundry to create a new droplet (container image). The staging process reuses the application code that was uploaded in your last push. The app config and deployment config don't change as a result of restaging. 

```
cf restage training-app 
```

Applications should be restaged when runtime dependencies *might* change but your app code has not changed. For example when you change an environment variable directly or by binding a service. If the config change or binding could result in different runtime behavior, you should restage.

A real life scenario might be binding a monitoring service to your app that includes an agent in the runtime (AppDynamics, NewRelic, etc). The agent needs to be added to the droplet during staging so that it will run in the same container process as the app code. In this case, running a `cf restart` would not be sufficient because the buildpack wouldn't add the necessary agent.

> When changing environment variables, the CLI recommends restaging because it does not know if the change will affect the droplet. This recommendation is based on the possibility that the environment change will result in a changed droplet. If you know for sure that the changes to the environment are only used by your application and not the staging process, a restart will suffice.

Restaging is necessary when the buildpack changes. This happens when the operators update the buildpack, effectively updating the runtime dependencies your apps could use. In this way, the runtime dependencies for your application are managed by the platform. This is in stark contrast to docker based systems where you are responsible for patching container images.

Another common restage scenario is when the stack (root file system) is changed. It's difficult to know for sure whether changed stack elements are in use by a runtime, so restaging after changing the stack is a common practice.

> You can view the stacks available on your Cloud Foundry with `cf stacks`. An application's stack is visible in the output of `cf app`.

### Re-pushing

Re-pushing is necessary when your application code changes.

When you re-push an application to Cloud Foundry, you overwrite almost everything. The cached app code is replaced with your latest push, and this new app code is sent through the staging process, causing a new droplet to be created. To ensure all running instances are updated, each existing container (instance) is destroyed and replaced using the new droplet.

The deployment config might change when re-pushing, depending on whether you update it. Existing values will only be overwritten if new values are provided. If you omit values, the existing ones will be used.

We'll be re-pushing an app in the update-strategies section next.
