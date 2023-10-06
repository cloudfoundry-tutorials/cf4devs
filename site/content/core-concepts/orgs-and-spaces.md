---
title: "Orgs & Spaces"
layout: "docs"
weight: 1
---

Organizations (orgs) and spaces are logical separations within a Cloud Foundry instance. Spaces live within orgs, and a single org can contain one or more spaces.

Orgs are often used to separate tenants or projects. For example, you may want to divide your Cloud Foundry instance into separate orgs for different areas of your business. Within an org you might have separate spaces for different lifecycle stages, like development, staging, and production.

While you're required to use orgs and spaces in Cloud Foundry, *how* you use them is up to you. 

## Targeting

To begin working with an org and/or space in Cloud Foundry, you must first target it. Targeting directs CLI commands to a specific org and  space. The `cf target` command is used to change your target. It can also be used to show the org and space you are currently targeting (if any). You can see your current target by running:

```
cf target
```

You can change the org and space you are using by:

```
cf target -o <THE_ORG> -s <THE_SPACE>
```

> You don't need to do this now. For the time being, we will remain in the default org and space.

## Scope and Names

In the previous section, we deployed an application to a space. Applications are always deployed to a space, and a space is always scoped to an org (you cannot push an app directly to an org). As you will see later in the course, other elements, including service instances and routes, are also scoped to spaces. As such, you need to target a space before you can begin managing that space's resources.

When you deployed the app using `cf push`, you gave it a name (via the manifest) of `first-push`. Naming the app meant you could easily refer to it in Cloud Foundry. While names can be used as defaults by some commands (for example in creating a route for your `first-push` app), they exist primarily for humans. We discuss resources names in more depth later in this module.

You can see list details of your app by using its name:

```
cf app first-push
```

Because apps are scoped to a space, app names need to be unique in that space. However, they do not need to be unique outside the space. You could therefore have an app named `first-push` in development, staging, and production spaces. Other users may have their own app called `first-push` in their spaces as well.
