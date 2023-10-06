---
title: "Update Strategies"
layout: "docs"
weight: 3
---

As you add new features, fix bugs, and generally improve your applications, you'll need to deploy these changes. Cloud Foundry makes it easy to do so with or without downtime. The choice is yours.

## Updating Deployment Configuration

When re-pushing, you use the same push command as when you first deployed your app. You can provide all of the same deployment configuration (service bindings, environment variables, instance counts, etc) or you can provide what has changed. Anything you don't overwrite will stay the same as before, except for the path. You always need to provide the path to the application bits.

## The `--strategy` Flag

The `--strategy` flag was added to the CLI in version 7. If you omit the `--strategy` flag when pushing updates, all app instances will be updated at once. While this is a fast method of deployment, it will cause downtime as all instances will be stopped at the same time.

To prevent downtime, you can specify `--strategy rolling` when pushing updates. With a rolling strategy, application instances are updated one at a time. First, a new instance with the updates is started and mapped to the same route as the old applications, then an old instance is removed. This process is repeated until all instances have been updated.

> Note, the `--strategy` flag is also supported by other commands, including `cf restart`. You can get more information by viewing the help output of the CLI.

### Rolling Deployment Implications

When using rolling deployments, it is important to be aware of the following:

- Application changes must be additive. During a deployment, Cloud Foundry serves the old and new version of your app concurrently. This could briefly cause user issues if you push backwards-incompatible API changes.

- Deployments do not handle database migrations. Migrating an app database when the existing app is not compatible with the migration can result in downtime.

Rolling deployments only run web processes through the rolling update sequence described above. The commands restart worker and other non-web processes in bulk after updating all web processes.

### The Old Way

In previous versions of Cloud Foundry, zero-downtime updates were achieved using a 'Blue-Green deployment' methodology. This is mentioned in the next section of this course; the new version of the app is pushed using a different name and route (un)mapping is used to cut over traffic from the live app deployment. While this method works, this approach results in a "new" application in the eyes of Cloud Foundry. Making zero-downtime updates a core feature of Cloud Foundry has simplified the full life cycle management of applications.

Blue-Green deployments were powerful but also problematic. Because the new version was pushed using a new app name (often something like `myapp-venerable`), Cloud Foundry treated this as a different application with its own unique GUID. Therefore, users had to make accommodations in logging systems (and queries), service discovery, and when viewing events. The event history of the old version would be independent from the new version and lost upon cleanup of the old application. Additionally, having two GUIDs requires workarounds in some service discovery systems.

## Try it: Rolling deployments

A simple static file app named `updating-app` is included, along with a manifest. The manifest deploys the app with five instances.

Deploy the app using the manifest:

```
cf push
```

Note the route assigned to this app. As in some of the previous exercises, you'll notice from the app manifest that the random route field is set to true, so will be randomly assigned by Cloud Foundry. You can retrieve the route at any time using `cf app updating-app`.

If you are on a system with the `watch` utility installed, you can view the process in action. `watch` will re-run a command on a given interval. If you do not have `watch`, you will need to manually re-run the commands below repeatedly to see the process in action. If you don't have `watch` don't worry - we demonstrate this in the video for this exercise.

With `watch`, in one tab start:

```
watch -n 0.5 curl -L <ROUTE-TO-YOUR-APP>
```

Verify you see "BLUE" in the output. This will curl the app every 0.5 seconds and will allow you to observe the update. 

In another tab, you can launch a different watch:

```
watch -n 1 cf app updating-app
```

Make a change to the app. Edit the index.html file located in the `updating-app` directory and change it to "GREEN", be sure to save it. Update the running application. In a separate tab, deploy the updates with a rolling strategy:

```
cf push --strategy rolling
```

In the tabs running `watch`, you will observe that you are routed to both `BLUE` and `GREEN`. As more `GREEN` instances are started, you will see more `GREEN` responses until all instances are updated. At this point, you no longer see `BLUE`. In the `cf app` watch, you will also see Cloud Foundry removing and replacing instances.

> If you have many app instances, you may not want to wait for all of them to be updated before the CLI returns. You can use the `--no-wait` flag on the push in these cases. When used, the CLI will return after the first updated instance becomes healthy.

Leave the app and the `watch` command running. In the next section, we will look at how to cancel an active deployment in the event you need to roll back.

## Cancelling a Rolling Deployment

You may notice an issue during a rolling deployment and need to rollback. You can achieve this by canceling a deployment with `cf cancel-deployment`. When cancelling a deployment, the app is reverted to the state before the deployment started by doing the following:

- Scaling up the original web process
- Removing any deployment artifacts
- Resetting the `current_droplet` on the app

The `cancel-deployment` command is designed to revert the app to its original state as quickly as possible, and does not guarantee zero downtime.

> Note: `cancel-deployment` only works with ongoing, rolling deployments. We will look at rolling back outside the scope of an active deployment in another section.

### Try It

Let's change the app, redeploy and cancel the deployment.

- Change the `index.html` to say `RED` and save it.
- Push the changes, this time also adding the `--no-wait` flag. This way you won't need a third terminal window.
- When the CLI returns, switch back to the window running `watch`.
- When you start seeing `RED`, cancel the deployment in the other terminal window with `cf cancel-deployment updating-app`.

You should see the `RED` instances role back to `GREEN`. If you wait too long, you will see a message like "No active deployment found for app." You can try again.

Lastly, clean up:

- Cancel the `watch` commands by hitting `CTRL-C` in those terminal windows.
- Delete the app using `cf delete updating-app`.
