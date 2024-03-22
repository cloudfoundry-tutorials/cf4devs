---
title: "Containerized Applications"
layout: "docs"
weight: 1
---

Before we jump into the different aspects of pushing and managing applications, let's review what goes into an application running in Cloud Foundry.

## What Goes into an App?

Let's discuss what we need to run your application and review how Cloud Foundry meets these needs. Remember that Cloud Foundry runs application instances in containers. It has been doing this since long before Kubernetes or Docker existed. Above and beyond what those solutions offer, Cloud Foundry also does all of the heavy lifting of creating container images and scheduling containers on appropriate hosts for you. You simply supply your application code and configuration.

1. **App Code**: As a developer, you are responsible for providing your application code to the platform. You do this with the `cf push` command.

2. **Runtime Dependencies**: To run your app code, Cloud Foundry needs runtime elements. This could be an interpreter for a Ruby app, the JRE (or JRE + Tomcat) for a Java app, or something like NGINX to serve static content. Runtime dependencies are provided by one or more buildpacks during the staging process. The app code and runtime dependencies are combined in a unit called a "droplet" during the staging process.

3. **Stack**: To run instances of your app, we need a filesystem for the container process. A "stack" is a prebuilt filesystem used in constructing the container image. When app instances are launched, a container is created "just in time" by combining the stack with the droplet (app + runtime dependencies).

4. **Application Config**: Configuration is external to your app. ([Twelve-factor app principles](https://12factor.net) guide us to inject this config via the environment). Cloud Foundry allows you to set environment variables directly, and also sets some defaults. The `VCAP_APPLICATION` environment variable provides information about the running application instance, including routes and other runtime config. The `VCAP_SERVICES` environment variable is used to inject service instance credentials and configuration.

5. **Deployment Config**: Lastly, deployment config is used to specify parameters for Cloud Foundry, including the number of instances (containers) of the app to schedule and the amount of memory and disk to allocate per instance. The app name used to refer to the app within Cloud Foundry, is part of the deployment config. App routes, if applicable, are also part of the deployment config. As the developer, you are able to specify these values.

In summary, as a developer, you bring your app code, tell Cloud Foundry the deployment config you want to apply, and optionally provide application config via environment variables. Cloud Foundry does the rest. There is no need to build, vet and manage container images, filesystems, runtimes, etc.
