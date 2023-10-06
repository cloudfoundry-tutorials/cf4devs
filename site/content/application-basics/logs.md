---
title: "Logs"
layout: "docs"
weight: 7
---

As a developer, you will frequently access application logs to debug your apps. Cloud Foundry uses a component called 'Loggregator' for streaming log output from applications and Cloud Foundry system components (in this course, we'll focus on application logs). Logs are incredibly helpful when troubleshooting.  Common issues you might see are apps running out of memory, route collisions, or pushing the wrong application payload.

## Following Logs in Real-Time

The CLI can stream new logs to your terminal:

```
cf logs training-app
```

You won't see any output until you access the `training-app`. Open the `training-app` URL and hit refresh a few times. Now that you've generated some traffic, log output should appear. You should see logs from the Cloud Foundry routers tagged with `[RTR/<some-index>]`.

You can exit streaming with `CTRL-c`, or you can continue to stream and start a new terminal window.

> Note: The log streaming functionality uses a websocket to stream logs in near real-time. If you cannot stream logs while on a corporate network, you should check with the network administrators to ensure websockets are allowed.

## Inspecting Recent Logs

You can also pass the `--recent` parameter to view only the recent logs for an app. This is useful if your application is producing a large volume of logs:

```
cf logs --recent training-app
```

The `--recent` buffer is finite in both space and time. If your app has been idle for a long period, you may not see anything in the recent logs.

## Log Drains

As mentioned at the start of this section, by default the Loggregator streams logs to your terminal. Logs can be drained to a third-party log management service via syslog forwarding if you need to persist or analyze logs.

Optional information on log drains is available in the [documentation](https://docs.cloudfoundry.org/devguide/services/log-management.html#user-provided).

## Events

There are two main types of Cloud Foundry events: audit events and usage events. Audit events are largely used to monitor actions taken against resources, such as app restarts, stops, scaling, route mapping, and many more.

You can view the most recent events of an app with

```
cf events <app-name>
```
Alongside each event you should be able to see the user that executed that particular event.

Optional information on events is available in the [documentation](https://docs.cloudfoundry.org/running/managing-cf/audit-events.html).

## Container Metrics

Metrics for Cloud Foundry application containers can be made available for viewing via CLI plugins (more on these later). While container metrics are outside the scope of this course, it is useful to know of their existence. Optional information on metrics is available in the [documentation](https://docs.cloudfoundry.org/loggregator/container-metrics.html).
