---
title: "Application Domains"
layout: "docs"
weight: 2
---

So far in this course, we have been using the default app domain for our routing, but usually, there are other domains available for us to use as well. You can see the list of available domains in a given space by running:

```
cf domains
```

For each of the domains listed in your Cloud Foundry deployment, you should see some additional information: the domain name, availability, whether it's internal, and the protocol.

Operators configure the default domain for applications. When a developer pushes an app without specifying a domain, a route is created using the default application domain. 

## Shared and Private Domains

A "shared" domain is available to all users in all orgs of a Cloud Foundry deployment. 

Private domains can be registered with Cloud Foundry by users with the OrgManager role. A private domain is scoped to an org by default, but can be shared with other orgs via `cf share-private-domain`. As an example, you could make `mycompany.com` available as a domain within the Cloud Foundry instance you are using. Then, a developer could deploy an app at `myapp.mycompany.com`.

DNS entries will need to be created by your DNS administrator for any private domains registered with a Cloud Foundry instance. These entries are made in your DNS provider, not in Cloud Foundry. Otherwise, routes on using the domain will not be resolvable. Additionally, you likely need to add SSL certificates to the request chain either through your Cloud Foundry provider or by using a 3rd party service like CloudFlare.

Let's create a non-resolvable private domain for practice.

```
cf create-private-domain <ORG> my-private-domain.exmample.com
```

Now we can map a route for the `training-app` under the private-domain (if the route does not already exist, `cf map-route` will first create it)

```
cf map-route training-app <DOMAIN> --hostname static
```

> Note the above domain will not resolve (the app is not accessible) as DNS for the above domain has not been updated. 


## HTTP veruss TCP Domains

When listing domains, a protocol of either `tcp` or `http` will be listed. A HTTP type domain means that only requests using the HTTP protocol are routed to apps with routes falling under that domain. Routing for HTTP domains is layer 7, and offers features like custom hostnames, sticky sessions, and TLS termination.

TCP domains can be used for requests over any TCP protocol, including HTTP. However, as TCP is layer 4 and protocol-agnostic, a lot of the features available in HTTP routing are not included. Currently, only Shared Domains can be of protocol type TCP.

> Support for TCP routing is optional and may not be available in all Cloud Foundry instances.

## External Domains

External domains are routable from outside of Cloud Foundry. The default app domain we have used so far is an example of an external domain. Any app that needs to be accessible from outside of Cloud Foundry will need to be created under external domain. We'll take a look at internal domains in the next section.

### Tidying Up

You can go ahead and unmap the `training-app` from the private domain, as we did in the previous section, and then delete the private domain (as it won't work without DNS updates).

```
cf delete-private-domain <DOMAIN>
```

> If you need help remembering the command for unmapping the route, look it up with `cf help -a`.
