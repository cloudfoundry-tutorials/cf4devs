---
title: "Advanced CLI"
layout: "docs"
weight: 1
---

In this section, we look at some of the more advanced functionality of the cf CLI.
 
## The Cloud Controller API

Behind the scenes, the CLI makes REST calls to the Cloud Controller, a Cloud Foundry component. The  Cloud Controller API is [documented here](https://v3-apidocs.cloudfoundry.org). At times you will need to invoke this API directly. For example:

- Automating application lifecycle in a CI/CD system
- Invoking an endpoint in the API that does not have a corresponding CLI command
- Generating reports or automated queries

`cf curl` enables you to invoke the API easily without having to manage authentication headers or use the full API url. The `cf curl` command uses your current target and authentication token. The API docs provide examples using `curl` directly (not `cf curl`). You can omit the authentication header and full API url from the examples when using `cf curl`.

> Tip: The API returns information in JSON format. It is helpful but not required to install the `jq` utility to parse JSON responses. 

### Using `cf curl` 

You can query the API for information on your applications by using:

```
cf curl /v3/apps
```

You will see a response in JSON format similar to:

```
{
   "pagination": {
      "total_results": 1,
      "total_pages": 1,
      "first": {
         "href": "https://api.cf.us10.hana.ondemand.com/v3/apps?page=1&per_page=50"
      },
      "last": {
         "href": "https://api.cf.us10.hana.ondemand.com/v3/apps?page=1&per_page=50"
      },
      "next": null,
      "previous": null
   },
   "resources": [
      {
         "guid": "98ed89e0-4b13-46b1-863c-8abf3b55b68f",
         "created_at": "2021-06-01T18:35:36Z",
         "updated_at": "2021-06-18T00:52:00Z",
         "name": "training-app",
         "state": "STOPPED",
         "lifecycle": {
            "type": "buildpack",
            "data": {
               "buildpacks": [
                  "go_buildpack"
               ],
               "stack": "cflinuxfs3"
            }
         },
         "relationships": {
            "space": {
               "data": {
                  "guid": "f5234cf8-2804-4cf8-aab6-d025a4e51714"
               }
            }
         },
         "metadata": {
            "labels": {
               "sensitive": "true",
               "env": "dev"
            },
            "annotations": {}
         },
         "links": {
            "self": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f"
            },
            "environment_variables": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/environment_variables"
            },
            "space": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/spaces/f5234cf8-2804-4cf8-aab6-d025a4e51714"
            },
            "processes": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/processes"
            },
            "packages": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/packages"
            },
            "current_droplet": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/droplets/current"
            },
            "droplets": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/droplets"
            },
            "tasks": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/tasks"
            },
            "start": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/actions/start",
               "method": "POST"
            },
            "stop": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/actions/stop",
               "method": "POST"
            },
            "revisions": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/revisions"
            },
            "deployed_revisions": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/revisions/deployed"
            },
            "features": {
               "href": "https://api.cf.us10.hana.ondemand.com/v3/apps/98ed89e0-4b13-46b1-863c-8abf3b55b68f/features"
            }
         }
      }
   ]
}
```

The API supports querying for records and fetching a specific record. Details of the API are well documented and therefore outside the scope of this course material.


## Plugins

The CLI is extensible through the use of plugins. Plugins are typically authored by the Cloud Foundry community rather than core Cloud Foundry development teams.

### Plugin Repository

A [plugin repository](https://plugins.cloudfoundry.org/) is available. This repository lists plugins created by the community for a variety of tasks.

These extensions are not built, maintained, or sanctioned by the Cloud Foundry Foundation. Therefore you should research the plugins you intend to use with regard to quality and security impact before installing them.

## Installing Plugins

Plugins are installed via the `cf install-plugin` command. Plugin documentation for newly-added commands is listed under a section labeled `INSTALLED PLUGIN COMMANDS` when you run `cf help -a`.

## Tracing Requests and Responses

Seeing as the CLI makes REST calls to the Cloud Controller, it can be helpful to see the requests and responses when debugging or working directly with the API. There are multiple ways you can enable debugging:

* Setting the `CF_TRACE` environment variable to `true` will cause the CLI to output the requests and responses as they are sent and received.
* The same type of request/response logging can be enabled using `cf config --trace=true`.
* Requests and responses can also be logged to a file by setting the `CF_TRACE` environment variable to the name of a file.

Try enabling tracing using one of the methods above and running some of the cf CLI commands we've looked at already in this course. Notice the information that is included in the output.

### Non-Interactive Authentication

Non-interactive authentication should be used when automating interactions with Cloud Foundry (such as in CI/CD pipelines). This can be achieved with both `cf auth` and `cf login` by providing the right parameters.

With `cf auth`, you can set the `CF_USERNAME` and `CF_PASSWORD` environment variables or you can pass in a username and password as arguments. However, using environment variables is typically preferred, provided you can set them without adding them to the command shell history where the automation is running.
