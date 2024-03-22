---
title: "Environment Variables"
layout: "docs"
weight: 4
---

Environment variables inject configuration values into applications. As the [12-factor app](https://12factor.net/config) principles state, we should "store config in the environment". In this section we'll test out passing environment variables to an app called `training-app`.

## Preparation

The golang application used in this section will display some basic information about the app itself, including its environment variables.

First, let's deploy the `training-app` using the supplied manifest. Go to the `training-app` directory, then deploy the app:

```
cf push training-app -f manifest.yml -p training-app.zip --random-route
```

Access the app in a browser and make sure you see can see the interface. You will notice that at this point the application UI is not displaying any environment variables.

## Setting environment variables

This app will display any environment variable that starts with `TRAINING_`. Set some environment variables (but don't restart or restage yet):

```
cf set-env training-app TRAINING_KEY_1 training-value-1
cf set-env training-app TRAINING_KEY_2 training-value-2
cf set-env training-app TRAINING_KEY_3 training-value-3
```

Notice the CLI provides a tip: `TIP: Use 'cf restage training-app' to ensure your env variable changes take effect`. If you access your app in a browser before restarting/restaging you will see why -- the app does not see the new environment variables yet.

Now restart the app and view it in a browser. (We will discuss restart versus restage in a later section). You should see the three environment variables you set above.

```
cf restart training-app
```

## Inspecting Environment Variables

Most apps do not (and should not) show environment variables in their publicly accessible UI. However, you can use `cf env` to inspect their environment variables and values.

```
cf env training-app
```

Be sure you have restaged or restarted your app so that the app sees the same values you see when using `cf env`.

> Before you restage or restart after changing environment variables, `cf env` will show the latest values while the app will only see and display the older values in its UI.


## Updating Environment Variables

You can change an environment variable value by using `cf set-env` and providing a new value:

```
cf set-env training-app TRAINING_KEY_3 training-value-3_1
```

Remember to restart the app to see the change.

## Adding Environment Variables to the Manifest

To ensure the environment variables are configured correctly on every push, be sure to add them to the manifest. Update your copy of the manifest to add an `env` block containing settings for the three `TRAINING_KEY_*` values previously set manually via `cf set-env`.

> **Hint**: If you are unsure of the syntax for adding environment variables in the manifest, you can see an example by generating a new manifest using the `cf create-app-manifest` command.

Delete the existing `training-app` and re-deploy using the updated manifest, and check that the environment variables are correct.

> Note: You should avoid putting secrets directly in the manifest. Instead, use variables in the manifest and store secrets outside of source control. 

## Unsetting Environment Variables

To remove an environment variable, you use `cf unset-env`. Because you can set variables via the CLI or a manifest, simply removing a value from a manifest and re-pushing will not work. You must unset the value via the CLI and remove it from the manifest.

```
cf unset-env training-app TRAINING_KEY_1
```

## Platform Environment Variables

When you read the environment variables for an app with `cf env`, you will have noticed that there were more than the user-provided values you set. Cloud Foundry also injects configuration for your application via environment variables. Two common variables are `VCAP_APPLICATION`, which provides configuration and information about the application instance, and `VCAP_SERVICES`, which provides configuration for accessing service instances. Applications can decide to use these environment variables if necessary (the sample application is reading and displaying some of these values). A complete list of platform environment variables is provided in the Cloud Foundry [documentation](https://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html#app-system-env).

### Environment Variable Groups

Environment variable groups are system-wide variables that Cloud Foundry operators can apply to all running apps and all staging apps. Environment variable groups are typically used to provide generally applicable, albeit optional, configuration values for a specific Cloud Foundry instance. Each group consists of a single hash of case-sensitive name-value pairs that are inserted into an app container at either runtime or staging. These values can contain information such as HTTP proxy information.

When creating environment variable groups, only the CF operator can set the value for each group, but authenticated users can view the environment variables assigned to their app. In the event you set an environment variable of the same name, the user-defined value(s) you provide will take precedence over environment variables provided by these groups. So they can effectively be overwritten on an app-by-app basis.

Platform operators configure environmental variable groups. As a developer, you will not be configuring these values. However, you can view any existing environment variable groups with the following commands:

```
cf running-environment-variable-group
```

```
cf staging-environment-variable-group
```

These commands will retrieve the contents of any running and staging variable groups.