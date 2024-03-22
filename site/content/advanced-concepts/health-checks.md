---
title: "Health Checks"
layout: "docs"
weight: 2
---

How does Cloud Foundry know an app is working? Health checks. An app health check is a monitoring process that continually checks the state of a running Cloud Foundry app. Cloud Foundry supports three types of health checks:

* `http` whereby a `GET` is performed against a web app on its default port - can be used with any app than can provide a `HTTP 200` response.
* `port` whereby a TCP connection is made to one or more ports - can be used where an app can receive TCP connections, including HTTP web apps. This is the default if no health check is specified.
* `process` whereby the process (PID) running in the container is monitored - useful for apps that don't support TCP connections e.g. a worker app.

As a developer, you can change health checks for an app.  Health checks can be set in the app manifest, or on the command line:

```
cf set-health-check <APP-NAME> <HEALTH-CHECK-TYPE> --endpoint <CUSTOM-HTTP-ENDPOINT>
```

```
---
  ...
  health-check-type: http
  health-check-http-endpoint: /health
```

>  Note that the `--endpoint` flag and `health-check-http-endpoint` field of the manifest are only applicable when using the `http` health check type.

After you set the health check configuration of a deployed app with the `cf set-health-check command`, you must restart the app for the change to take effect.

Let's update the health check type for the `training-app` to use a HTTP health check instead of the default port check:
```
cf set-health-check training-app http
```

Once the health check method is updated, the app needs to be restarted for the changes to take effect.
```
cf restart training-app
```

Ta-da, `training-app` is now using a HTTP health check.

You can view the currently-configured health check on an app like so:

```
cf get-health-check training-app
```

> Note: When we set the health check, we didn't provide a custom endpoint with the `--endpoint` flag even though we chose a check of type `http`. When this flag is omitted, Cloud Foundry defaults to using `/` as the endpoint. This suffices for a training example, but applications should provide a dedicated health check endpoint when using a HTTP health check. The endpoint needs to respond within 1 second to be considered healthy by Cloud Foundry, so relying on non-dedicated endpoints serving business logic could compromise the response time and health check results.

You can test the health check functionality by simulating a hung instance following the steps below.

In one terminal window, start viewing the app logs:

```
cf logs training-app
```

In a separate terminal window, scale the app to one instance:

```
cf scale -i 1 training-app
```

Then kill the app's process, which will cause the app to stop responding but not terminate the app:

```
cf ssh training-app -c 'kill -STOP $(pgrep sample-app)'
```

If you did this without the health check in place, you would see that the application hangs, but Cloud Foundry does not attempt to restart it. With the health check in place, you will see a message in the logs saying “liveness check unsuccessful”, and Cloud Foundry will restart the application.