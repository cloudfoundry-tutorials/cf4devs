---
title: "Internal Domains"
layout: "docs"
weight: 3
---

For security reasons, it is desirable that some applications be inaccessible from outside of Cloud Foundry. This could include back-end RESTful data services, for example. Routes based on internal domains are only resolvable by other apps in the same Cloud Foundry deployment.

Each Cloud Foundry deployment has a default internal domain of `apps.internal.` You can create routes under this domain and map them to your applications. This internal domain is visible in the output of `cf domains`.

> Internal domains are an optional feature and may not be available in all Cloud Foundry instances.

## Creating a Route on the Internal Domain

To demonstrate setting up an internal route, we move the training app to the `apps.internal` domain. We will then deploy an nginx proxy and enable it to talk to the training-app.

### Moving to an internal domain

Creating a route is the same regardless of the domain. We can create and map the route in one command:

```
cf map-route training-app apps.internal --hostname <HOSTNAME>
```

At this point, the app is still routable from the external domain as well. We can remove this route by unmapping it:

```
cf unmap-route training-app <CF_APPS_DOMAIN> --hostname <HOSTNAME>
```

At this point, if you attempt to access the application from a browser, you will not be able to. 

### Deploying the proxy

A simple nginx proxy is provided in the `proxy` directory along with a manifest. The manifest if parameterized and will require a few inputs:

```
cf push \
    -f proxy/manifest.yml \ # path to the manifest
    -p proxy \ # path to the source directory
    --var route=<HOSTNAME>.<CF_APPS_DOMAIN> \ # The route for nginx. Use the external domain and hostname removed from the training-app above
    --var proxied_route=<HOSTNAME>.apps.internal \ # The internal route for the training-app
    --var proxied_port=8080" # The internal port (default) for the training-app
```

If you were to try and access the proxy app now, you would receive a 502 bad gateway error. The proxy is configured, but traffic from the proxy to the training-app needs to be explicitly allowed in Cloud Foundry through a network policy.

### Network policy

Now, the training-app is only routable from inside of Cloud Foundry, however, Cloud Foundry will prevent any app from accessing the static app unless we explicitly allow it through a network policy. This prevents apps that might be deployed by others from accessing internal apps without explicit permission. 

```
cf add-network-policy nginx-proxy training-app
```

Now, if you access the proxy app, it should work. You may need to wait a minute for the policy change to propagate.

> Note: It's also possible to enable access to internal applications across spaces and orgs by providing the `-s` and `-o` parameters when creating a network policy.

If necessary, you can also remove the network policy:

```
cf remove-network-policy nginx-proxy training-app
```
