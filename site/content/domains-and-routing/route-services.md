---
title: "Route Services"
layout: "docs"
weight: 4
---

In some instances, Cloud Foundry developers might want to transform or process requests before they reach an app. Common use cases include authentication, rate limiting, and caching services. Route services, which bind an app’s route to a service instance, are a type of service that developers can use to apply such transformations to app requests.

Through integrations with service brokers and, optionally, with the CF routing tier, providers can offer these services to developers with a familiar, automated, self-service, and on-demand user experience.

There are three models for implementing route services. We'll take a look at all three, and discuss the advantages and disadvantages of each.

## Fully Brokered

In this model, Cloud Foundry routers receive all traffic to apps in the deployment before any processing is done by the route service.

Developers can bind a route service to any route. When a route is bound to a route service, the CF router will send its traffic to that service. After the route service processes a request, it sends it back to the load balancer in front of the router.

When the request arrives at the CF router for a second time, the router recognizes that the route service has already handled it, and so forwards it directly to the app.

A route service can run inside or outside Cloud Foundry, so long as it either accepts the request by making a fresh request to the requested URL (or some other location), or rejects it. Route services offered through a service broker advertise themselves through the CF marketplace. Developers can then create instances of the service and bind it to their apps with the following commands:

```
cf create-service BROKER-SERVICE-PLAN SERVICE-INSTANCE 
cf bind-route-service YOUR-APP-DOMAIN SERVICE-INSTANCE [--hostname HOSTNAME] [--path PATH]
```

Developers can configure the service either through the service provider’s web UI, if it has one, or by passing arbitrary parameters to the `cf create-service` call via a JSON object provided to the `-c` flag.

Advantages:
* Developers can use a service broker to dynamically configure how the route service processes traffic to specific apps.
* Adding route services requires no manual infrastructure configuration.
* Traffic to apps that do not use the service does not pass through the route service, and so doesn't need to make so many network hops.

Disadvantages:
* Traffic to apps that use the route service make more network hops than it would under the static model (below).

## Static Brokered

In this model, the operator installs a static route service, such as a piece of hardware, in front of the load balancer. The route service runs outside CF and receives traffic for *all* apps running in the CF deployment. The service provider creates a service broker to publish the service to the CF marketplace. As with a fully-brokered service, a developer can use the service by instantiating it with `cf create-service` and binding it to an app with `cf bind-route-service`.

With the static brokered model, route services are configured on an app-by-app basis. When you bind a service to an app, the service broker directs the route service to process that app’s traffic before passing it on to the load balancer.

Advantages:
* Developers can use a service broker to dynamically configure how the route service processes traffic to specific apps.
* Traffic to apps that use the route service requires fewer network hops.

Disadvantages:
* Adding route services requires manual infrastructure configuration.
* Traffic to apps that do not use the route service makes unnecessary network hops. Requests for all apps hosted on CF pass through the route service component.

## User-Provided

If a route service is not listed in the CF marketplace by a broker, a developer can still bind it to their app as a user-provided service instance. The service can run anywhere - inside or outside CF - provided it meets the [Service Instance Responsibilities](https://docs.cloudfoundry.org/services/route-services.html#service-instance-responsibilities) requirements. The service also needs to be reachable by an outbound connection from the CF router.

This model works like the fully-brokered service model, but without the broker. Developers configure the service manually, outside of CF. They can then create a user-provided service instance and bind it to their app with the following commands, supplying the URL of their route service:

```
cf create-user-provided-service SERVICE-INSTANCE -r ROUTE-SERVICE-URL
cf bind-route-service DOMAIN SERVICE-INSTANCE [--hostname HOSTNAME]
```

Advantages:
* Adding route services requires no manual infrastructure configuration.
* Traffic to apps that do not use the service makes fewer network hops because requests for those apps do not pass through the route service.

Disadvantages:
* Developers must manually provision and configure route services outside the context of CF.
* Traffic to apps that use the route service makes more network hops than under the static model.

