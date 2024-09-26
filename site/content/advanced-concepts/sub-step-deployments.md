---
title: "Sub-step Deployments"
layout: "docs"
weight: 5
---

The cf CLI provides commands that can give you granular control over the app push process. Using these commands, you can choose to execute individual steps (sub-steps) of a `cf push` in isolation.

## Why Should I Sub-Step it?
Common use cases for a sub-step deployment include:
* Updating a third party system before staging an app
* Retrying failed stagings without downtime
* Calling external services to report audit data during a push
* Scanning a droplet before deploying
* Integrating with a change request system

To support these workflows, Cloud Foundry divides apps into smaller building blocks. These building blocks include:

* **App:** The top-level resource that represents an app and its configuration.
* **Package:** The source code that makes up an app.
* **Build:** The staging process. Creating a build combines a Package with a buildpack, and builds it into an executable resource.
* **Droplet:** An executable resource created in a Build.
* **Manifest:** A file used to apply configuration to an app and its underlying processes.

## Using sub-step commands

To give a practical example of how this all comes together, we will replicate the traditional `cf push` command by going through each of its sub-steps.

For demonstration, we will use the `training-app`. However, we need to delete it first so that we are starting fresh.

First off, let's "create" your app with the cf CLI:
```
cf create-app training-app
```

If you run `cf apps` you'll see you now have a `stopped` app named `training-app`. 

From the `training-app` directory, create a package for the app and copy the package GUID from the output:
```
cf create-package training-app -p training-app.zip
```

Apply the manifest:
```
cf apply-manifest -f manifest.yml
```

Now stage the package you created:
```
cf stage training-app --package-guid <PACKAGE-GUID>
```

Assign the droplet to your app (you'll find the droplet GUID near the end of the output of `cf stage`):
```
cf set-droplet training-app <DROPLET-GUID>
```


Finally, start your app:
```
cf start training-app
```

All done. Through the steps above, we have replicated the `cf push` command.

## Roll Back to a Previous Droplet
In some cases, you might want to roll back to an older droplet, for example, if a bug is discovered. Let's look at how we could roll back our  instance to an older version.

List the droplets for your app, copy the droplet GUID you'd like to roll back to:
```
cf droplets training-app
```

If you've followed the above steps, you'll only have one droplet uploaded - but we'll pretend you have several.

Stop your app:
```
cf stop training-app
```

Set the app to use the desired droplet:
```
cf set-droplet my-app <DESIRED-DROPLET-GUID>
```

Start your app again:
```
cf start training-app
```

