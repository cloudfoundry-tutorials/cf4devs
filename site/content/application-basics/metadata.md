---
title: "Metadata"
layout: "docs"
weight: 5
---

Cloud Foundry provides the ability to add metadata to resources such as spaces and apps. This metadata provides additional information about the resources in your Cloud Foundry deployment. This can be a useful tool when operating, monitoring, and auditing Cloud Foundry.

There are two types of metadata: labels and annotations.

## Labels

Labels are key-value pairs that allow you to identify and select Cloud Foundry resources. Labels are searchable. For example, if you have labeled all apps running in development, or all spaces containing internet-facing apps, you can then find those apps by searching for their labels.

Labels can be set via the CLI. Let's add some labels to `training-app`:

```
cf set-label app training-app env=dev
```

We should be able to see that our labels have been set correctly in the app details:

```
cf labels app training-app
```

Now we can use labels as a search function to list all of the apps with the key/value pair `env=dev`:

```
cf apps --labels 'env=dev'
```

Multiple labels can be used to filter search results. Let's add another:

```
cf set-label app training-app sensitive=true
```

Now we can search for both labels using a comma-separated list:

```
cf apps --labels 'env=dev,sensitive=true'
```

The only app shown in the output should be `training-app`.

Like always, labels should be added to the app manifest.

```
metadata:
  labels:
    sensitive: true
```

## Annotations

Annotations allow you to add non-identifying metadata to CF resources. Unlike labels, you can't query based on annotations, and there are fewer restrictions than for key-value pairs. For example, you could include information about how the resource was deployed (via CI or non-CI), or tool information for debugging purposes.

Annotations cannot be added using a regular CLI command. Instead you'll need to add them via the app manifest. In an app manifest, annotations are included in the metadata block:

```
metadata:
  annotations:
    contact: "bob@example.com"
  labels:
    env: dev
```
