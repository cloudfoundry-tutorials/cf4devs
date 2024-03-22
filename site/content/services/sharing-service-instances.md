---
title: "Sharing Service Instances"
layout: "docs"
weight: 3
---

The ability to share service instances between spaces allows apps in different spaces to share databases, messaging queues, and other services. This eliminates the need for development teams to use a messy combination of service keys and user-provided services to bind their apps to a service instance provisioned in another space with the `cf create-service` command.

Sharing service instances improves security and auditing, and also provides a more intuitive user experience.

Sharing service instances is an optional feature that may be unavailable in some Cloud Foundry instances.

## Sharing Instances

Service instance sharing must be enabled at a global level by your CF operator. Once enabled, _shareable_ service instances can be shared between spaces (and also across orgs). You must have the Space Developer role assigned to your user in the spaces you intend to share service instances with.

You can find out whether a particular service is shareable with `cf curl`:

```
cf curl /v3/service_offerings
```

The output of `cf curl` is JSON and can be difficult to read. If the `jq` command is available on your system, try piping to it to make the output easier read.

```
cf curl /v3/service_offerings | jq
```

> Note: User-provided service instances (covered in the next section) are not shareable. 

This will output a JSON object containing a list of service offerings in the marketplace. Each object has a field specifying either `"shareable": true` or `"shareable": false`.

Developers have full access to shared service instances. However, they cannot update, rename, or delete it.

Let's say you have two apps in different spaces that need to communicate with one another via a message queue. In this case, the development team in Space A can create a new instance of a messaging queue service, bind it to their app, and share that service instance with Space B. A developer in Space B can then bind their app to the same service instance, and the two apps can begin publishing and receiving messages from one another.

Let's try this out. First, let's share our DB instance with a second space.

> If you're joining the course at this point, you'll need an active service instance to follow along with these exercises. If you don't already have one, head to the [Managed Services](../managed-services) section for instructions on provisioning a service instance.

Run `cf spaces` to view the other spaces available in your current org. We'll be sharing this service with the `services` space. Enable that with the following:

```
cf share-service training-app-db -s services
```

```
cf service training-app-db 
```

Now our training-app-db service instance will be available to apps in the `services` space.

```
cf target -s services
```

```
cf service training-app-db 
```

## Unsharing Instances

You can unshare a service instance if you have the Space Developer role in the originating space. A service instance can't be deleted or renamed while it is still shared across spaces, so unsharing is a prerequisite for these operations.

Let's target the `development` space and stop sharing our RabbitMQ instance with the `services` space:

```
cf target -s default
```

```
cf unshare-service training-app-db -s services
```

Now if we run `cf service`, you might notice that when we unshared our service instance with the `service` space.

```
cf service training-app-db 
```

When you unshare a service instance, all bindings in unshared spaces will be deleted. For this reason it's important to check what bindings exist in shared spaces before unsharing a service instance.
