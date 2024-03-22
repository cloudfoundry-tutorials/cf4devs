---
title: "Troubleshooting"
layout: "docs"
weight: 4
---

Sometimes you'll need to troubleshoot app deployments on Cloud Foundry. As an app developer, it's important to understand how to work through problems. This section discusses some common failures and general troubleshooting commands that can be useful when diagnosing problems.

## Routing Conflict

Cloud Foundry allows multiple apps, or multiple versions of the same app, to be mapped to the same route. It's this feature that enables Blue-Green deployments and A/B testing.

Mapping multiple apps to the same route may cause undesirable behavior in some situations, as incoming requests will be routed at random to one of the apps on the shared route. If you suspect a routing conflict, run `cf routes` to check the routes in your installation.

If you find that two apps that shouldn't share the same route are, choose one app to re-assign to a different route and follow the procedure below:

```
cf unmap-route <YOUR-APP-NAME> <OLD-ROUTE>
```

This will remove the existing route from that app.

```
cf map-route <YOUR-APP-NAME> <NEW-ROUTE>
```

This will map the app to a new, unique route.

## Routing Collisions

For much of this course, we have used the `random-route` feature of the CLI. This feature attempts to construct a unique route for your app by randomly selecting 2 words from a dictionary. This is not a feature you should **ever** use in production as it is not guaranteed to result in conflict-free route.

Instead, you should specify a unique hostname and/or route for each of your apps. If you try to push an app that would use a route that already exists, your deployment will fail.

## Troubleshooting Commands

This list includes a set of helpful commands used for troubleshooting app deployments. Some of these should be familiar from previous sections. You can run these against the `training-app` for demonstration purposes.

Show the health and status of an app's instances: current state and uptime, and CPU, memory, and disk usage.
```
cf app training-app
```

Return the environment variables set in the container environment.
```
cf env training-app
```

Information about app crashes, including error codes.
```
cf events training-app
```

Return recent logs. You can remove the `--recent` flag to stream the app stdout and stderr.
```
cf logs training-app --recent
```

## Accessing Apps over SSH

If you need to troubleshoot an instance of an app, you can gain SSH access to the app using the SSH proxy and daemon.

For example, one of your app instances may be unresponsive, or the log output from the app may be inconsistent or incomplete. You might want to SSH into the individual instance to troubleshoot.

### Enabling SSH

The app SSH feature can be disabled at the Cloud Foundry deployment, the space, and the app level. An app is SSH-accessible only if operators, SpaceManagers, and SpaceDevelopers all grant SSH access at their respective levels. 

You can check if SSH is enabled for an app with:
```
cf ssh-enabled <APP_NAME>
```

SSH for an app can be enabled with:
```
cf enable-ssh <APP_NAME>
```

You can check if SSH is enabled for all apps in a space with:
```
cf space-ssh-allowed <SPACE_NAME>
```

SSH for a space can be enabled with:
```
cf allow-space-ssh <SPACE_NAME>
```

Corresponding commands to disable SSH at the space and app level also exist.

You will need to restart your application after making changes to either SSH setting above:

```
cf restart training-app --strategy rolling
```

### App SSH

Let's try this for one of our existing app deployments. 

```
cf ssh training-app -i 0 
```

From the ssh session, you can:

- View the files in the container. The `app` directory contains your application code as processed/assembled by the buildpack. 
- Verify runtimes and dependencies used by your application.
- Test connectivity to external dependencies like service instances or other apps.

There isn't anything to troubleshoot here for now. You can exit by typing `exit` when you're ready. Don't forget to restart that instance as a precaution:

```
cf restart-app-instance training-app 0
```

