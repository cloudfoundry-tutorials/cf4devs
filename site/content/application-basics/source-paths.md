---
title: "Source Paths"
layout: "docs"
weight: 1
---

Source paths let you specify a path to the application when running `cf push`. It is important to understand what you are pushing to Cloud Foundry.

## Using the current directory

When you `cf push` without specifying a path, the contents of the current directory you ran the push command from are pushed up. This is what we did in the first-push exercise. However, you should be careful with this as it can result in unexpected behavior when you are not in the directory you expect. Therefore, it is always safer to explicitly specify a path.

## Specifying a path

You can use the `--path (or -p) <directory or file>` flag to give the location of the directory containing the application content. The path can also point to a specific application artifact like a jar or zip file.

You can also specify the path in the manifest file:

```
---
  ...
  path: /path/to/app/bits
```

> A quick word on manifests vs the CLI: Broadly, you can think of the CLI commands you run against an app as experimental. Any declarations made via the CLI can and should be, reflected in the manifest if you'd like them to persist. Manifests live in version control and are shared among developers in a way that CLI commands cannot. Throughout the course, we will use a combination of CLI commands and manifests.

If you declare the `-p` parameter, this will take precedence over a path declared in the manifest.

If you push without specifying a path in the manifest or a `-p` parameter, the CLI will push the contents of your current working directory (we did this when we pushed our `first-push` app earlier in the course). It's a bad idea to get into this habit, as unexpected things can happen (like accidentally pushing a folder of your home movies).  Therefore, you should always specify a source path.

## Specifying a ZIP file

Cloud Foundry supports pushing zip files containing your app code. An app packaged as a zip file exists in the `zip-file` directory of the course materials. Let's push it, being sure to specify the path to the zip file.

> This app doesn't have a manifest with it so we'll need to specify some parameters via the CLI.

```
cf push zip-with-src-path -p app.zip -b staticfile_buildpack -m 32M -k 64M --random-route
```

If you access the app in a browser, you should see the Cloud Foundry logo.

While specifying a path is best practice for all app deployments, when pushing zip files, it is mandatory. If you don't pass a path to a zip file, Cloud Foundry won't unzip the file before deploying it. The implications of this vary depending on the buildpack you're using. Our goal is to avoid any unexpected behavior.

Let's test this out ourselves with the staticfile buildpack and see what happens. Be sure you are in the `zip-file` directory before pushing.

```
cf push zip-no-src-path -b staticfile_buildpack -m 32M -k 64M --random-route
```

If you access this app in a browser, you should see a 403 error. If you access the app's URL and append it with `/app.zip` the app package will be downloaded to your local machine. When we omitted the path, Cloud Foundry didn't unzip the files. The staticfile buildpack assumed you wanted to pass the entire directory contents during staging, even though it only contains a single file.

Again, make sure you always provide a path when pushing.

## Tidy up

Before we move on, let's clean up a little. Delete the `zip-no-src-path` app as we won't need it anymore.

```
cf delete -r zip-no-src-path
```

Rather than deleting the `zip-with-src-path` app, let's rename it to something more sensible so that we can use it in later sections:

```
cf rename zip-with-src-path static-app
```