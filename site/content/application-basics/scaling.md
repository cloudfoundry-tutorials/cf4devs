---
title: "Scaling"
layout: "docs"
weight: 6
---

## Horizontal Scaling

When you scale an application horizontally, you manipulate the number of instances of that application up or down, usually in response to an increased or reduced user load.

In Cloud Foundry, horizontal scaling doesn't result in downtime as traffic is only routed to available instances. When new instances are created, traffic isn't routed to those instances until they pass a health check (we'll cover health checks later in this course).

Let's start by scaling the `training-app` up to two instances:

```
cf scale -i 2 training-app
```

You can see the instances have been scaled successfully by running `cf app training-app` and observing `instances: 2/2` in the output.

## Vertical Scaling

When you scale an application vertically, you are manipulating the resources allocated for each application instance container. In Cloud Foundry, you can change memory and disk allocations.

Let's scale the training-app instances down in both disk and memory.

```
cf scale -m 48M -k 256M training-app
```

What happened? Scaling vertically involves downtime as the containers are recreated with different resource allocations. This is an important point to consider when scaling vertically in production. Therefore, you should strive to right-size your resource allocations per instance during development and rely on horizontal scaling in production.

You can view the allocations for an app by running `cf app <app-name>`.

As always, if you'd like to make any scaling changes permanent, these values should be updated in a version-controlled app manifest. For example:

```
---
applications:
- name: training-app
  memory: 48M
  disk-quota: 256M
  instances: 2
```

