---
title: "Tasks"
layout: "docs"
weight: 3
---

A task is an app or script whose code is included as part of a deployed app, but runs independently in a separate container.

Unlike an app (a long-running process), tasks run for a finite amount of time, and then stop. They run in their own isolated containers that share the application's deployment config. After a task finishes, Cloud Foundry destroys the container that ran it.

Tasks are used for a multitude of purposes, including database maintenance and migration tasks, indexing, backups, and report generation.

## Running a Task

The `training-app` includes a task that will echo a statement to standard output. The task is a simple bash script and is packaged as part of the app code. If you unzip the `training-app.zip` source you will see this script in the `tasks` directory.

You can run the task using `cf run-task`. With this command you can specify the amount of disk and memory allocated to the tasks' container. Given our task is lightweight, we can allocate few resources:

```
cf run-task training-app -m 8M -k 64M --name sample-task --command tasks/sample-task.sh
```

You will notice we also gave the task a name: `sample-task`. Like an app name, this is a human-readable name used to reference the task inside Cloud Foundry. Cloud Foundry will assign a task id and then queue the task for execution.

## Task Status

The execution of tasks is asynchronous. Some tasks may run quickly, while others may take hours. For this reason, it is useful to be able to check on the status of a task.

```
cf tasks training-app
```

You should see your task has completed successfully. Note that you can also terminate an ongoing task by running `cf terminate-task <TASK-ID>` (however, our example task executes too quickly for you to be able to do this).

## Task Logs

You can see the output of the task execution by looking in the logs.

```
cf logs --recent training-app
```

You will see the task has printed a statement.

## Terminating a task

If you have a long running task, you may need to terminate it at some point. You can do this with the `cf terminate-task` command.

## Implementation considerations

It is important that you design your tasks to be durable and idempotent. A task runs in a container and it is possible that the container will crash or be rescheduled while a task is running. Or, you may decide you need to terminate a long running task. Therefore, you need to ensure your tasks are idempotent (in the event a task is run more than once) and can recover from failure or rescheduling without corrupting your data or environment.