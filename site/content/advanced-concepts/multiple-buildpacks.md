---
title: "Multiple Buildpacks"
layout: "docs"
weight: 7
---

In some cases you might want to push an app with more than one buildpack. Perhaps your company needs to include a specific security, compliance, or logging agent with every application. Or perhaps your application is written in more than one language. The multiple buildpack funcationality can be used to achieve this.

In Cloud Foundry you can specify these buildpacks through your app manifest or flags passed to the cf CLI.


## Passing Multiple Buildpacks via the cf CLI

You can list as many buildpacks as you need when running `cf push`

```
cf push <YOUR-APP> -b <BUILDPACK-1> -b <BUILDPACK-2> -b <BUILDPACK-3>
```

Be mindful that the sequence of buildpacks is important. When passing buildpacks to the cf CLI, the last buildpack you specify sets the start command (so in the example above that would be BUILDPACK-3).

> Declaring buildpacks with the cf CLI will override any buildpacks declared in the app manifest.

## Multiple Buildpacks in the Manifest

Although imperative CLI commands are powerful tools for experimentation, it's important that we understand how to translate these changes into the app manifest, as this file can be version-controlled (mitigating the risk of CLI-driven snowflakes).

As is the case when passing buildpacks to the cf CLI, order is important. Make sure your final buildpack is the one whose start command you'd like to run.
```
  ---
    ...
    buildpacks:
      - buildpack-1
      - buildpack-2
      - buildpack-3
```

If you'd like to understand buildpacks and buildpack sequencing in more detail, have a read of the [docs](https://docs.cloudfoundry.org/buildpacks/understand-buildpacks.html).

## Try it

Let's have a go at pushing an app with parts written in two programming languages. In `apps/multi-buildpack-app` you'll find a Go app that runs a web server. Whenever someone hits the `/` path, the app runs a ruby script, captures its output, and then sends it back to the client in its response.

Find out the names of the buildpacks you need to pass to `cf push`, and then deploy the app - taking care to pass the buildpack names in the right order. If it important that the go lang buildpack be last as it starts the webserver.

Once its up, verify that the `multi-buildpack-app` is working by visiting the UI in a browser and checking that the text displayed includes the `Hello world!` output of the ruby script.

## Tidy up

When you're done, please delete the `multi-buildpack-app`, as we won't be using it again.