---
title: "Advanced Concepts"
iconifyicon: "cloudfoundry"
description: "In this module, we cover some of the more advanced features of Cloud Foundry."
type : "docs"
weight: 7
---

In this module, we cover some of the more advanced features of Cloud Foundry.

- [Advanced CLI](advanced-cli): A look at some of the more advanced features of the CF CLI.
- [Health Checks](health-checks): App health checks are monitoring processes that continually check the status of a running Cloud Foundry app. This section discusses the different types of healthchecks and their use cases.
- [Tasks](tasks): Tasks are finite processes whose code is included as part of a deployed app, but runs independently in its own isolated container.
- [Sidecars](sidecars): Unlike tasks, sidecars are additional processes that run in the same container the application.
- [Sub-step deployments](sub-step-deployments): Cloud Foundry allows you to take granular control over app pushes; you can choose to perform only some steps of the `cf push` process, or specific actions normally executed as part of running `cf push`.
- [Apps with Multiple Processes](multiple-processes): Describes how Cloud Foundry enables pushing an app that creates multiple processes from the same codebase.
- [Using Multiple Buildpacks](multiple-buildpacks): In instances of multi-language applications, Cloud Foundry allows you to specify multiple buildpacks to be used with that app.
- [App Revisions](app-revisions): App revisions represent code and configuration used by an app at a specific time, and allow you to roll back to previous revisions.

