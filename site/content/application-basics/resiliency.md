---
title: "Resiliency"
layout: "docs"
weight: 8
---

By performing `cf scale`, you asked Cloud Foundry to ensure you have two instances of the app running. Behind the scenes, Cloud Foundry is ensuring this is so. Let's test it.

To see this happen, we can watch the logs. In a terminal window, tail the logs: 

```
cf logs training-app
```

## Killing an App Instance

The application has a `/kill` endpoint that will crash the instance programmatically.

> WARNING: Don't build apps with a `/kill` endpoint! This for training purposes only.

Go to your application in a browser. Tack on `/kill` to the URL and hit enter. You will see a '502 Bad Gateway' error as you will have killed this instance. Quickly switch back to the terminal window where you are tailing the logs. You should see that Cloud Foundry (very quickly) detects an instance is missing and creates a new one.

If you go back to your browser, remove the `/kill` from the URL, you should be able to refresh and see that you are only being routed to the live instance. Once the new instance starts up, Cloud Foundry once again load balances across the healthy instances.

When you are ready, you can stop tailing the logs by hitting `CTRL-C` in the terminal window.

## Pretty cool. So what happened?

Cloud Foundry is constantly monitoring the actual count of the running application instances and comparing that number to the desired count. If it finds an issue, Cloud Foundry will correct it (in our case, by creating a new instance). And just like during scaling, when the new instance becomes available Cloud Foundry routes traffic to it. Cloud Foundry knows an instance unhealthy if it fails a health check. We discuss health checks later in the course.

**And what didn't happen?**

A lot. All apps get this level of care from Cloud Foundry. You don't have to do anything other than use Cloud Foundry.