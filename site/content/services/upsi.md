---
title: "User-Provided Services"
layout: "docs"
weight: 4
---

In the last few sections, we showed you how to create and use service instances provisioned from the marketplace. But what if your application needs to connect to a service not available in the marketplace? What if it needs to connect to an existing database or message queue? User-provided services instances (UPSI) enable this.

A user-provided service instance is a service instance whose credentials (config) are provided by a user, not a broker. The provisioning of any resources related to such service instances also occurs outside of a broker, i.e. not via the `cf marketplace`. For example, such a service instance could represent a database created 'manually' in a cloud provider or running on bare metal. Or it could be an existing database in your organization, as an existing HR database.

A user-provided service instance is a set of key/value pairs that is provided to an application. The application consumes this config through the `VCAP_SERVICES`, which contains binding information for all service instances. Typically, apps will not distinguish between a service instance provisioned by a broker and a user-provided service instance.

## Creating a User-Provided Service Instance

You can create a service instance using the `cf create-user-provided-service` (or `cf cups` using the shortcut) command. `cf cups` supports both a non-interactive mode and an interactive mode. We will look at both.

Let's assume we want to create two user-provided service instances, `non-interactive` and `interactive`. Each will have three keys: `user`, `password` and `url`.

To create a UPSI named `non-interactive` in non-interactive mode, you provide well-formed JSON using the `-p` flag:

```
cf cups non-interactive -p '{"user":"some-user", "password":"some-password", "url":"some-url"}'
```

> The above JSON format is well-formed and works on Unix-based systems. The format may be different if you are using a Windows terminal, and will depend on the specific Windows terminal you are using. You can consult the CLI help text for appropriate formats on Windows and necessary escape sequences.

To create a UPSI named `interactive` in interactive mode, you provide the key names using the `-p` flag:

```
cf cups interactive -p "user, password, url"
```

The CLI will prompt you to provide values for each of the keys. This mode is useful if you are not confident working with JSON.

You should be able to see both of your service instances by running `cf services`.

## Inspecting

You can view the values of a user-provided service instance by binding it to an application and then inspecting the environment variables for that application. Currently a CLI command to directly view the values does not exist, though there is an API endpoint that can be curled. The process of binding an UPSI is exactly the same as that for binding a service instance provisioned from the markeplace. Let's bind and inspect both instances created above:

```
cf bind-service training-app non-interactive
cf bind-service training-app interactive
cf env training-app
```

You should see both instances and their key/value pairs listed under the `VCAP_SERVICES` environment variable. Among other things, the training app prints out a list of service instances it is bound to. However, if you access the app in a browser, you will not yet see the new services. You first need to restart (or restage):

```
cf restart training-app
```

Now, if you access the app in a browser you should see both instances listed.

Of course, you should update the manifest to ensure the service instance bindings are included. This happens in a `services` block:

```
  services:
  - training-app-db
  - non-interactive
  - interactive
```

## Updating

Updating a UPSI is very similar to creating one, except the command is `cf update-user-provided-service` (or `cf uups`). As is the case when creating, you can update a UPSI interactively or non-interactively.

When you update a user-provider service instance, you are overwriting all its values - not patching. Therefore you must provide all keys and values to the update command. For this reason, it is good practice to inspect a UPSI before updating it. This will ensure that you have the old values in your terminal window's history as reference.

Let's update the `url` value of the `interactive` upsi:

```
cf env training-app
cf uups interactive -p "user, password, url"
```

For the `user` and `password` fields, use the same values as before. For the new `url` feel free to provide anything you want.

If you again inspect the environment of the training-app you should see the change.

```
cf env training-app
```

Like before, your app won't see the change until it is restarted (or restaged).

```
cf restart training-app
```

## Special UPSIs

There are a couple of special types of UPSI that have their own associated flags. You might be able to identify them if you run `cf cups --help`.

### Streaming App Logs to a Service

You can easily stream app logs to a log aggregation service that isn't available in the marketplace. The `-l` flag of the `cf cups` command is used to create a log drain to the external service.

```
cf cups my-user-provided-log-service -l syslog://example.log-aggregator.com
```

The above URL is just an example. If you decide to stream logs to a 3rd party solution, consult your 3rd party logging system for your unique URL. This is optional and is beyond the scope of this class.

### Proxying App Requests to a Route Service

Route Services are another optional feature of Cloud Foundry. They are used to transform requests to an app (or apps) before the request reaches the app. More information on route services is available in the [documentation](https://docs.cloudfoundry.org/services/route-services.html). 

When creating a UPSI for a route-service you need to pass the url of that route service with the `-r` option. For example:

```
cf cups my-user-provided-route-service -r https://my-route-service.example.com
```

## Binding/Unbinding/Deleting

As you saw above, the process of binding an UPSI to an app is the same as for a service instance provisioned by a broker. The same is true for unbinding and deleting (we covered this in a previous section). Therefore, if we want to unbind and delete our UPSIs we need to do the following:

```
cf unbind-service training-app non-interactive
cf unbind-service training-app interactive
cf restart training-app
cf delete-service non-interactive
cf delete-service interactive
```

You should be able to run `cf services`, inspect the app's environment, and access the app in a browser to confirm the UPSI is no longer available in the app or your space.
