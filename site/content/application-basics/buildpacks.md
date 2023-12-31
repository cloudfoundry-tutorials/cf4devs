---
title: "Buildpack Basics"
layout: "docs"
weight: 3
---

Before we continue, let's briefly discuss this "buildpack" thing we have referenced a few times. Buildpacks are responsible for containerizing your application. Essentially, they provide the runtime environment your application needs. The python buildpack knows how to construct runtimes for python apps, the Java buildpack for Java, and go buildpack for go-lang, etc. The static file buildpack we have used so far uses nginx to serve static content. 

Buildpacks construct runtimes during the "staging" phase of an application (more on this later).

## Available Buildpacks

So far, we've been using the `staticfile_buildpack` in our push commands.  But there are many others. 

To view the available buildpacks in your Cloud Foundry instance run:

```
cf buildpacks
```

The listed buildpacks are configured by your Cloud Foundry operator. These available buildpacks are referred to as "system" buildpacks as they are available in the system for all users.

## Git Buildpacks

In addition to the system buildpacks, many Cloud Foundry instances allow you to specify the URL of a specific version of a buildpack in a git repository. In this case, Cloud Foundry will download the specific version of the buildpack and use it to stage the application. 

> Note the use of git buildpacks can be disabled by Cloud Foundry administrators. 

If enabled, you could deploy the training-app using a specific version of a git buildpack with:

```
cf push -b https://github.com/cloudfoundry/staticfile-buildpack/tree/v1.5.21
```

Of course, you would want to add this value to your manifest if you planned to use it. We'll look more at buildpacks later in this course.