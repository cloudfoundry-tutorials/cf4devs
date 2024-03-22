---
title: "Manifests"
layout: "docs"
weight: 2
---

Manifests have been mentioned a handful of times already in this course. In the 'Source Paths' section, we deployed and configured `static-app` entirely via command-line arguments. And while this worked fine for our first deployment, if we wanted to deploy it again in another space or share the configuration with a colleague, we'd need to recall the CLI arguments we used. Sharing CLI commands isn't a very reliable way to deploy our app, especially if something changes in our configuration.

Instead, we use a manifest file to specify values for all configurable parameters. Using a manifest file is a good practice because it can be kept in version control. A version-controlled manifest is consistent and can be shared between developers. It also allows manifest updates to be rolled out to multiple deployments quickly and efficiently, especially when integrated as part of a CI/CD pipeline.

## Creating manifests via the CLI

You can write a manifest from scratch manually by following the [documentation](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest-attributes.html). But that requires a fair amount of YAML wrangling. Instead, Cloud Foundry can create a manifest for you based on the current state of a deployed application. 

Be sure you are in the `zip-file` directory.
Then use the CLI to generate a manifest for the static app:

```
cf create-app-manifest static-app
```

The CLI will generate a manifest file in your current directory.

> Note: the name of the file is `static-app_manifest.yml`, not `manifest.yml`, as it's named after the app. To use this manifest on a push, you need to supply the `-f` flag and the path to the manifest (or rename the file to `manifest.yml`, which is the default that the CLI will look for in the current directory).

Looking at the app manifest, you'll notice it includes the `stack` property. You didn't specify this when you pushed the app, so Cloud Foundry used its default value.

## Testing the Manifest

Let's test our new manifest. Start by deleting the `static-app`, then re-pushing it with the manifest.

```
cf delete -f -r static-app
cf push -f static-app_manifest.yml 
```

> Try running `cf delete --help` to see what the flags in the command above do.

If you used the exact commands above, the app will not deploy correctly. When you open the app route in a browser, you will see a 403 error. This is the same error you saw in the `Source Paths` section. Open the manifest and see if you can figure out what's wrong.

> You may not see the 403 error because of browser caching. Refresh the page to see the error.

Cloud Foundry can only include the config elements in the generated manifest that it knows about. The path to the `app.zip` file is missing from the generated manifest. Cloud Foundry doesn't know the path you used on your local filesystem. Fix this by adding the path to the manifest, or by pushing with the `-p` parameter. How you choose to fix this will depend on your use-case. For now, let's push with the `-p` parameter:

```
cf push -f static-app_manifest.yml -p app.zip
```

The app should now correctly display the Cloud Foundry logo again.

## CLI vs Manifest Precedence


When working with manifests, you can override their values on the command line. You can test this out by re-pushing but specifying a different disk allocation.

```
cf push -f static-app_manifest.yml -p app.zip -k 128M
```

If you want to make this change permanent, you should add it to the manifest. Otherwise, the next time you push the manifest _without_ the `-k 128M` parameter the current value is overridden.

This reiterates the point made earlier in this section; passing parameters to the CLI is good for experimenting, but permanent changes should be reflected in a manifest that lives in version control.

> You can also explicitly ignore the manifest when pushing using the `--no-manifest` flag.

## Variables in Manifests

Manifests support the parameterization of values. For example, you likely want to use a different route for the development version of your app than for the production version. You could parameterize the `route` value and have it set on `push`. This allows you to use the same manifest for dev and production. 

Variables are declared inside double parenthesis: i.e. `((my-variable))`. To demonstrate, let's parameterize the number of instances in our manifest by editing the file:

```
---
applications:
- name: static-app
  instances: ((instances))
  buildpacks:
  - staticfile_buildpack
...  
```

We can then push with:

```
cf push -f static-app_manifest.yml -p app.zip --var instances=1
```

While this looks similar to `cf push -i 1`, variables are required to be passed in during push. 

It is good practice to define a vars file for each environment (development, staging, prod, etc) rather than relying on variables on the command line. In this way, we would be declaring (in files in source control) all of the deployment configuration for each environment. We could therefore define a file `static-app_dev.yml`:

```
instances: 1
```

And then push with:

```
cf push -f static-app_manifest.yml -p app.zip --vars-file=static-app_dev.yml
```