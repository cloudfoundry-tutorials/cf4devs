---
title: "Multiple Processes"
layout: "docs"
weight: 6
---

A single app in Cloud Foundry can consist of multiple processes running in separate containers. This is different from the sidecar processes we looked at earlier, which share a single container.

One of the most common use cases for multiple processes is a web app that has both a UI process and a worker process.

## Push an App with Multiple Processes

An app with multiple processes can be pushed by either passing a Procfile to `cf push`, or by declaring the multiple processes in the app manifest. We'll start by trying the Procfile approach.

## Passing Procfiles to `cf push`

To push an app that creates multiple processes from the same codebase, you list each process in the manifest. Here, you need to specify a start command for each process as the buildpack won't know how to distinguish between each process.

```
---
applications:
- name: multi-process
  buildpacks:
  - nodejs_buildpack
  processes:
  - type: web
    instances: 1
    memory: 64M
    command: node main.js web
  - type: worker
    instances: 2
    memory: 32M
    command: node main.js worker
```

> Note: You can also specify start commands by providing a Procfile. If you'd like to learn more about Procfiles we recommend taking a look at the [Cloud Foundry API documentation](https://v3-apidocs.cloudfoundry.org/index.html#procfiles).

Let's try pushing the `multi-process` app. 

```
cf push --random-route
```

You should now be able to view the running processes on the app:
```
cf app multi-process
```

You should see the details of your running processes in the output. By default, the web process has a route and one instance, and other processes have zero instances (in our case we specified two instances for the worker process, which overrides the default).

## Scale a Process
Processes can be scaled independently. There's an additional `--process` flag that can be passed to the `cf scale` command to achieve this.

Let's scale the web process to two instances:
```
cf scale multi-process --process web -i 2
```

We can do the same for the worker process:

```
cf scale multi-process --process worker -i 3
```

## cf SSH
When running apps with multiple processes, you use pass the `--process` flag to `cf ssh` into the container for a specific process. For example:
```
cf ssh multi-process --process web
```

## Tidy up
When you're done with the exercise, you can exit the `web` container and delete the multi-process app. We won't be using it again in this course.
