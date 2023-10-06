---
title: "Service Keys"
layout: "docs"
weight: 2
---

In the last section, we showed you how to provision services from the marketplace, using Postgres as an example. We also showed you how to connect an application running on Cloud Foundry to your service instance. But what if you needed to connect to the database using a database client? Or perhaps you need to connect a 3rd party monitoring tool to the Postgres database (or whatever service you provisioned). This is the role of service keys.

Service keys are to generate a unique set of credentials for use outside of an application context. This can be useful if you need to connect directly to a database or hook up a monitoring tool that does not support service binding. Service brokers create and destroy service keys.

## Creating a Service Key

> If you're joining the course at this point, you'll need an active service instance to follow along with these exercises. If you delete the `training-app-db` at the end of the last section, you should recreate it now before proceeding.

Let's create a service key for the service we provisioned in the previous section. For demonstration purposes, we can pretend that these credentials will be used by a monitoring tool and name the key accordingly:

```
cf create-service-key training-app-db monitoring-creds
```

The `training-app-db` argument is the name of our service. The `monitoring-creds` argument is the name we have chosen for the service key for our `training-app-db` service. We gave the service key a descriptive name so that the humans reading it will better understand its function.

## Viewing Service Key Values

You can view the credentials of the service key using `cf service-key`:

```
cf service-key training-app-db monitoring-creds
```

You can then use these credentials as you wish. In our scenario, for example, we might provide them to a monitoring tool. They can also be passed to `cf ssh` to create a tunnel to your service instance.

## Tunneling

Service keys are used to configure an SSH tunnel to your service instance. This will allow you to use a local client like the `psql` client to connect to your service by tunneling through the running application. To do this, you'll need to pass the relevant credentials from your service key to the `cf ssh` command as follows:

```
cf ssh -L <ANY-AVAILABLE-PORT>:<SERVICE-KEY-HOSTNAME>:<SERVICE-KEY-PORT> YOUR-HOST-APP
```

Once the SSH tunnel to your service is open, open another terminal window and use the relevant CLI tool to connect to your instance on localhost and your chosen port. For example, if you were accessing a Postgres instance you would use the `psql` command line client.

> We recommend getting in the habit of generating a unique service key when accessing a service instance. It is tempting to read the `env` for a bound app and use those credentials. However, when you re-use the same credentials, the audit trail of who (or what in the case of an app) performed some action is lost.

## Deleting a Service Key

You can delete a service key using `cf delete-service-key`:

```
cf delete-service-key training-app-db monitoring-creds
```

Since service keys are not bound to applications, no other action is needed to delete them.
