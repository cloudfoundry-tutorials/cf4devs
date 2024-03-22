---
title: "Considerations"
layout: "docs"
weight: 5
---

Following a few simple guidelines for app design often allows apps to run unmodified on Cloud Foundry. Many of these guidelines are derived from the [12factor.net](https://12factor.net) app best practices. These practices can result in significant efficiencies for development teams.

## Stateless Apps

As described in the [Processes](https://12factor.net/processes) section of The Twelve-Factor App, apps running on Cloud Foundry should strive to be 'stateless'. A stateless app doesn't write files to the local file system. This important because:

**1. Local file systems are short-lived**

If an app instance stops, any local disk changes are lost. When the instance restarts, the app will start with a new disk image. So although your app can write local files while it is running, those files will disappear when the app restarts.

**2. Instances of the same app don't share a local file system**
   
Each app instance runs in its own container. So a file written by one instance is not visible to other instances of the same app. If the files are temporary, this should not be a problem. However, if your app needs data to persist across app restarts, or it needs to be shared across all running instances of the app, the local file system should not be used. Cloud Foundry recommends instead using a shared data service, like a database or blobstore. This will also ensure that your app is horizontally scalable.

## Stateful Applications

Cloud Foundry can support stateful workloads provided the optional [volume services](https://docs.cloudfoundry.org/devguide/services/using-vol-services.html) component is available. This is an optional add on which can be configured and deployed by Cloud Foundry operators.  

## Deploying Large Apps

Large or slow-starting applications may require special considerations when running in cloud-based environments including Cloud Foundry.

### Timeouts

The deployment process involves uploading, staging, and starting the app. Cloud Foundry has a default time limit for each of these phases (which can be overridden by your administrator):
- Upload: 15 minutes
- Stage: 15 minutes
- Start: 60 seconds

You can configure cf CLI's staging, startup, and timeout settings to override settings in the manifest.

The `CF_STAGING_TIMEOUT` environment variable controls the maximum time (in minutes) that the cf CLI waits for an app to stage after Cloud Foundry successfully uploads and packages the app.

`CF_STARTUP_TIMEOUT` controls the maximum time (in minutes) that the cf CLI waits for an app to start.

`cf push -t <TIMEOUT>` controls the maximum time (in seconds) that Cloud Foundry waits between starting an app and receiving a healthy response and can also be set in the app manifest.

```
---
  ...
  timeout: 80
```

When you use the `-t` flag, the cf CLI will override any timeout value set in the manifest. All of these settings should be considered when pushing a large app.

> Note: you should always run `cf apps` to review the status of your app. The above commands will override cf CLI timeouts. Where there are discrepancies between CLI and Cloud Foundry timeouts, your app might successfully start even though the cf CLI reports `App failed`.

### Other Considerations

Customized timeouts are just one of the tools available when pushing large apps. Others include:
* Pushing only the files that are necessary for your app. You can use a `.cfignore` file to list files in your app directory that you want to exclude.
* Ensuring you specify adequate values for your app's memory and disk space allocation.
* Having a network connection that's fast enough to upload your app within the 15-minute limit. The minimum recommended speed is 874 KB per second.

More details on pushing very large apps can be found in the [Cloud Foundry documentation](https://docs.cloudfoundry.org/devguide/deploy-apps/large-app-deploy.html).
