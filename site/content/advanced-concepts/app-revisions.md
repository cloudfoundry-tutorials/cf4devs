---
title: "App Revisions"
layout: "docs"
weight: 8
---

App revisions represent code and configuration used by an app at a specific point in time. The latest app revision represents the code and config that are currently running in your app.

> Note that this feature is currently in Beta.

## Why would I use App Revisions?
You might use revisions if:
* **You want to view revisions for an app:** This can help you understand how your app has changed over time.
* **You want to roll back to a previous revision:** You can redeploy an older version of the app without needing to track its previous state yourself or have multiple apps running. When you create a deployment and reference a revision, the revision deploys as the current version of your app.

## When is a Revision Triggered?
Revisions are triggered automatically whenever the following events occur:
* A new droplet is created for an app
* An app’s environment variables are changed
* A custom start command for an app is added or changed
* An app rolls back to a prior revision

> By default the Cloud Foundry API retains a maximum of 100 revisions per app.

## List the Revisions on an App
To list the revisions for an app, we need to retrieve that app's guid and then perform a `cf curl` against the API.

Let's take a look at the revisions for the `training-app`. 

```
cf revisions training-app 
```

Whenever a new revision is created, the details of the event that triggered that revision are included in its description field. For example, say you update an environment variable with `cf set-env` and then restart the app in question. The revision would then include a description similar to:
```
"New droplet deployed. New environment variables deployed."
```

The currently deployed revision will be tagged with `(deployed)`. Deployed revisions are revisions linked to started processes in an app

## Roll Back to a Previous Revision

To roll back to a previous revision, you'll need the revision number from the `revision` column. Pick a previous revision and rollback:

```
cf rollback training-app --version <REVISION_NUMBER>
```

## Disable Revisions for an App

App revisions are enabled by default. If you want to disable revisions for an app, you can manually turn them off using `cf curl`:

```
cf curl /v3/apps/<APP-GUID>/features/revisions -X PATCH -d '{ "enabled": false }'
```

Try disabling app revisions for the training app and then trying to select another revision.


You can re-enable app revisions by amending the `cf curl` command slightly.
```
cf curl /v3/apps/<APP-GUID>/features/revisions -X PATCH -d '{ "enabled": true }'
```
