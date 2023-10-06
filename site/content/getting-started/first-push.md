---
title: "Deploy your first app"
layout: "docs"
weight: 3
---

Cloud Foundry is a purpose-built platform created to simplify the developer experience when deploying and managing applications. Hence the Cloud Foundry haiku:

    Here is my source code,
    Run it on the cloud for me.
    I do not care how.

With that in mind, let's take a quick look at deploying applications on Cloud Foundry. This is just an introduction; there are far more customizations and capabilities explored throughout the course.

## cf push

You deploy apps to Cloud Foundry with the `cf push` command.

There's nothing special about the app we will be deploying - it's a simple static application written for training purposes, named `first-push`. You'll find the `first-push` application, in the `/applications` directory of the course resources.

In your terminal, change directories so that you're in the `first-push` directory:

```
cd applications/first-push 
```

Inside this directory, alongside the application, is a file called a manifest (`manifest.yml`). The manifest provides directives to Cloud Foundry on how it should run the app.

You can now deploy the `first-push` app from this directory by running:

```
cf push
```

By default, the `push` command looks for a file named `manifest.yml` in the current directory and uses it to deploy the application.

You can view the manifest used to deploy your application. Let's look at the directives in the `manifest.yml`:

- `name: first-push` - The name of the application in Cloud Foundry. The name should be a descriptive name for use by humans and can be anything you want.
- `instances: 1` - The number of instances of the application Cloud Foundry should create.
- `memory: 32M` The amount of memory allocated to the container for each application instance.
- `disk_quota: 64M` - The amount of disk allocated to the container for each application instance.
- `random-route: true` - Specifies that Cloud Foundry should generate a random route for accessing the app.
- `buildpacks:` - The buildpack(s) used to containerize your application.
  - `staticfile_buildpack` - In this case, we only need the staticfile buildpack.

### Checking your Work

The push should take about a minute. If everything is successful, you should see output for your running application similar to:

```
name:              first-push
requested state:   started
routes:            first-push-active-quokka-dy.<my-domain>
last uploaded:     Mon 24 May 11:52:30 BST 2021
stack:             cflinuxfs3
buildpacks:
  name                   version   detect output   buildpack name
  staticfile_buildpack   1.5.17    staticfile      staticfile

type:            web
sidecars:
instances:       1/1
memory usage:    32M
start command:   $HOME/boot.sh
     state     since                  cpu    memory     disk       details
#0   running   2021-05-24T10:52:41Z   0.0%   0 of 32M   0 of 64M
```

The application has a user interface that shows some details about the application. You can copy the URL of your application from your terminal output under `routes` and open it in a tab in your browser.

### Wait, What Just Happened?

In short, you deployed an app using a single command! It would have looked the same regardless of the language of the app. The CLI on your machine uploaded the app bits to Cloud Foundry and provided some information about what should happen.

Cloud Foundry took your app bits and used a [buildpack](https://buildpacks.io) to create a container image with your app, plus any necessary runtime dependencies. The resulting image was then run in a container. Once your app was running, Cloud Foundry began to automatically route traffic to it (hence your ability to access it in a browser). We discuss this process in more detail later in the course.

### And What _Didn't_ Happen?

You _didn't_ build an image with a tool like Docker (though Cloud Foundry supports Docker, too). You didn't install a runtime or manipulate any file systems. You didn't manually provision any resources like compute and storage. You didn't create and deploy a load balancer or reserve any ports. You didn't update routing tables or do any health checks. You just typed `cf push`. Pretty cool, right?

The rest of the course will build on these experiences.
