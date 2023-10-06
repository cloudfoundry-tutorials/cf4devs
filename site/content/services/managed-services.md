---
title: "Managed Services"
layout: "docs"
weight: 1
---

As an application developer, you likely need to connect your application to external services like a database or message queue. Managed services in Cloud Foundry give you, the developer, the ability to discover and provision such services on demand. 

## The Marketplace

The marketplace is where you can view all of the services available for provisioning. These services can range from databases to volume services, such as NFS. You can view all of the services available to you with the CLI:

```
cf marketplace
```

The list of marketplace services can be lengthy, and you might want to use `grep` as a shortcut to narrow it down. Let's say we are looking for a Postgres service. We could pipe the output of `cf marketplace` into grep:

```
cf marketplace | grep postgres
```

> Note: The services offered, and the names of those services, can vary between Cloud Foundry deployments. You may have to replace `postgres` in the command above with the name of a service offered in your Cloud Foundry if Postgres is unavailable.

Once you've found the service you are looking for, you can view the details of that service.

```
cf marketplace -e <SERVICE_NAME>
```

You should see information on each service and plan (or tier) available.

## Provisioning Service Instances

Once you know what services are available, you can provision (create) a service instance using a specific plan. Again, the `<SERVICE_NAME>` and `<PLAN>` will vary depending on what is available in the Cloud Foundry instance you are using.

> If Postgres isn't available to you, pick another service. The selection of Postgres is arbitrary in this example. We continue to reference Postgres for simplicity in the rest of the exercise.

```
cf create-service <SERVICE_NAME> <PLAN> training-app-db
```

The `training-app-db` argument is our chosen name for the service. You can see the service instances available in the space by running:

```
cf services
```

### Binding a Service Instance

Binding is the process of generating credentials (config) for a service instance and making them available to an application through the `VCAP_SERVICES` environment variable. You can bind the service instance to your app using:

```
cf bind-service training-app training-app-db
```

> Do not restage or restart yet.

You can view the binding, and its configuration, by inspecting the `VCAP_SERVICES` environment variable:

```
cf env training-app
```

If you access the `training-app` in a browser, you will see the app doesn't yet know about the new service instance. Remember you need to restart (or restage) the application first to pick up the config change in the environment.

```
cf restart training-app
```

If you access the app in a browser, you should see the service instance information listed. 

Of course, you should update the manifest to ensure the service instance bindings are included. This happens in a `services` block:

```
  services:
  - training-app-db
```


### Unbinding a Service Instance

The process to unbind a service instance is similar to binding:

```
cf unbind-service training-app training-app-db
```

If you inspect the environment you will see the config removed from the `VCAP_SERVICES` environment variable:

```
cf env training-app
```

However if you access the app in a browser, you will see it still knows about the service instance. To update the config, you need to restart (or restage):

```
cf restart training-app
```

Accessing the app in a browser shows it no longer knows about the service instance.

### Deprovisioning a service instance

A service instance may be bound to more than one application or none. Unbinding only removes access for a previously-bound application; it doesn't delete the service instance or any data that it holds.

A service instance can be deprovisioned and deleted completely via the CLI (do not delete the postgres service instance now, as we'll be using it in the next section).

```
cf delete-service training-app-db
```

This will instruct the broker to delete the service instance completely.

> Note that you cannot delete a service instance that is still bound to an application. Service instances have to be unbound from all applications before deleting them.


## Service Brokers

Service brokers advertise services and plans in the marketplace, provision and deprovision service instances, and generate and revoke credentials used in service bindings. The [Open Service Broker API](https://www.openservicebrokerapi.org/) (OSBAPI) is an open standard developed by Cloud Foundry and supported in many cloud platforms, including Kubernetes. This standard allows developers to consume and manage services on demand through a standard API.

### Service Availability

Many service brokers can be added to a Cloud Foundry instance, each offering one or more services and plans. The management of service brokers falls to Cloud Foundry operators; you need to be an admin to register CF-wide service brokers. Developers are more likely to be a consumer of the services and plans they offer, though they can also develop their own service brokers using a [space-scoped service broker](https://docs.cloudfoundry.org/services/managing-service-brokers.html#register-broker).

In some cases you might be working across multiple spaces within a Cloud Foundry deployment. It is possible that the available services will vary between spaces. Operators control what services are available in each org.

### Space-scoped brokers

Unlike standard service brokers, a space-scoped broker's service plans are only available to users in that space. Also, unlike standard service brokers, they can be managed by Space Developers. So if you find yourself needing to create a new service broker for your space, you can do so as long as you have the Space Developer role.

Check `cf create-service-broker --help` to see how you could do this.

> Standard service brokers can be configured to publish certain plans to certain orgs, but only space-scoped brokers can provide this control at the space level.
