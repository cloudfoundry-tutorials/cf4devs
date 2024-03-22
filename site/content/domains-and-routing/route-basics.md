---
title: "Route Basics"
layout: "docs"
weight: 1
---

Cloud Foundry's routing model provides developers with flexible capabilities to securely and efficiently route traffic to applications. In this section, we'll take a look at manipulating routes, internal and external domains, and some of the capabilities that this model brings to developers. In Cloud Foundry, apps and routes have a many-to-many relationship.

## Anatomy of a Route

A route consists of a hostname concatenated with a domain. Routes must be unique within a Cloud Foundry instance. For example, we currently have an app deployed with a hostname beginning with `training-app` on a shared domain. (We will discuss domains in the next sections of the course.) For example, the route `training-app-path-industrious-lemur-qf.cfapps.us10.hana.ondemand.com` contains the hostname `training-app-path-industrious-lemur-qf` and domain of `cfapps.us10.hana.ondemand.com`.

## Creating Routes

You can see all of the routes in your current space using:

```
cf routes
```

The `training-app` should still be running, but it has an ugly hostname because we originally used the `--random-route` feature. That route is cumbersome and strange, so let's create a new one. You can do this with the command `cf create-route`:

```
cf create-route <CF_APP_DOMAIN> --hostname <SOME_UNIQUE_HOSTNAME>
```

`<CF_APP_DOMAIN>` is the domain under which our route will be created. Use the default apps domain for your Cloud Foundry instance. If you want to check what this is, run `cf routes` and check the value under the `domain` column for  `training-app`.

The last argument, `<SOME_UNIQUE_HOSTNAME>`, can be any name that is unique to that domain. You could try something like `training-app-YOUR_NAME`.

### A Quick Reminder on Route Collisions

As mentioned earlier in the course, routes must be unique within the Cloud Foundry deployment you are using. Route collisions occur when you try to reserve a route that already exists in another space in the same Cloud Foundry deployment. The `--random-route` flag has been used on numerous occasions in this course as it generates a route name that is unlikely to already be in use.

You are responsible for ensuring your apps avoid route collisions. You can do this by assigning a unique hostname yourself, or you can use the `--random-route` flag. Remember that `--random-route` is not _guaranteed_ to generate a unique name (the name could already be in use), and should be used judiciously in non-real-world scenarios like training or testing.

## Mapping Routes

When you create a route, you are reserving that route for use within a space. Now that you have a route, you can associate it with, or "map" it to, your `training-app`.

```
cf map-route training-app <CF_APP_DOMAIN> --hostname <SOME_UNIQUE_HOSTNAME>
```

You can see the routes mapped to an app using:

```
cf app training-app
```

You should see the old randomly-generated route starting with `training-app`, plus the new route you just created. You can now access your `training-app` via both the new route and the old route.

## Unmapping Routes

If you want to remove the old route, you first need to unmap it from your app.

```
cf unmap-route training-app <CF_APP_DOMAIN> --hostname <OLD_HOSTNAME>
```

Replace `<OLD_HOSTNAME>` with the old hostname for your `training-app`. Check that the route is no longer associated with the app using:

```
cf app training-app
```

## Deleting Routes

The old route is no longer associated with the our `training-app`, but the route still exists. We can check this by running:

```
cf routes
```

A route can be deleted using:

```
cf delete-route <CF_APP_DOMAIN> --hostname <OLD_HOSTNAME>
```

Run the above command replacing the placeholders with values for the app domain and hostname used by the old `training-app` route. You can verify the route has been deleted by re-running `cf routes` and checking the output.
