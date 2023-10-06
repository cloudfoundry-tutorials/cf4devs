---
title: "Resource Names"
layout: "docs"
weight: 3
---

You may have already noticed that the objects you create in Cloud Foundry have resource names assigned. For example, we ran `cf push` in a previous section, and we named the application `first-push` (defined in the app's manifest).

Resource names are important. You'll often refer to them when performing actions with the CLI, and in some cases, names are set according to a default. Think about the `first-push` example again. The app manifest includes `random_route: true`. This directive instructs Cloud Foundry to create a random route for our app using the resource name. If the `random-route` directive had not been set, a default route would have been created based on the resource name we chose i.e. `http://first-push.<mydomain.io>`.

Most resource names you encounter as a developer are scoped to a space. This means you can have apps with the same name in different spaces. For example, you might use the same name for apps deployed across the spaces development, staging, and production.

> You'll need to be wary of routing collisions where app names are duplicated across spaces, but we'll discuss that later on.

## GUIDs

Along with resource names, objects created in Cloud Foundry are assigned a globally unique identifier (GUID). Like resource names, an object's GUID will sometimes be passed to CLI commands. Unlike resource names, guids are globally unique.

## Renaming

You can rename certain objects in Cloud Foundry. When an object is renamed, the GUID does not change.

Let's test this out on the `first-push` app. Before we do, let's look at its current GUID:

```
cf app first-push --guid
```

Now, let's try renaming it:

```
cf rename first-push renamed-app
```

Once this change succeeds, if you run `cf app renamed-app --guid`, you will notice that the app GUID is the same (and so is the app route). The route can be manually updated, and we'll look at mapping and unmapping routes later in the course.

## Tidy up

You can go ahead and delete the `renamed-app` now - we won't be needing it for the rest of this course. 

```
cf delete -r renamed-app
```

The `-r` flag tells Cloud Foundry to also delete the route. We will discuss routes more in an upcoming section.
