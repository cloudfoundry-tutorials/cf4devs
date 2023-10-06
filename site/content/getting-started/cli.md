---
title: "Command Line Interface (CLI)"
layout: "docs"
weight: 1
---

The Command Line Interface (or CLI) is used to interact with Cloud Foundry (CF) instances via a [REST](https://www.codecademy.com/articles/what-is-rest) API. The `cf` CLI exposes human-friendly commands to users of the platform and is **common core**, meaning it works with all Cloud Foundry distributions.

## The CF API

The `cf` CLI is communicating with the [Cloud Foundry API](https://v3-apidocs.cloudfoundry.org), enabling developers to make requests to the API in a user-friendly way.

> You can also make requests to the API directly via `cf curl`, but this tends to be more complex. We will speak about `cf curl` a bit more later on.

Throughout this course, we will be using the latest version of the `cf` CLI [(v8)](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html), which supports by the latest version of the CF API [(v3)](http://v3-apidocs.cloudfoundry.org). It is important to make sure you are using `version 8+` as we will be utilizing v3 features throughout the course.

* Install the CLI by following the [installation instructions](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html) for **version 8 of the CLI**.  
* Ensure you are running **version 8** of the CLI by running `cf version`.

## Documentation

The CLI is extensively self-documenting, so being familiar with navigating it is extremely helpful.

As a summary:

* `cf help` displays help for the most frequently used commands
* `cf help -a` display help for all available commands.
* `cf <command> -h (or --help)` displays the detailed help for executing a particular command.

If you run `cf <command>` without the necessary parameters, the CLI will output the detailed help text as if you ran `cf <command> --help`. However, omitting the `--help`  and assuming the CLI will always output the help text is risky as not all commands require additional parameters. For example, if you were to run `cf push` expecting to see the help text and a manifest exists in your current directory, you could unintentionally push an application. For that reason, it is helpful to get used to the `cf <command> --help` workflow.

Try running `cf help -a` to view all of the available `cf` commands, then run the `--help` flag on a couple of commands to familiarize yourself with the help output.

> If you are studying for the Cloud Foundry Certified Developer exam, you can access `cf help` during the exam as the `cf` CLI is installed in the exam system.

### Aliases

Many commands have aliases (for example, `cf m` as a shortcut for `cf marketplace`). Aliases are listed in the help descriptions. For example, under the `Services integration:` section in `cf help`, you should see:

```
marketplace,m
```

The `m` after the comma is the shortcut. As you become more familiar with the more common CLI commands, shortcuts can save you some time.

## Internationalization

The CLI supports displaying text and descriptions in multiple languages. The name of the commands won't change but help text and command descriptions show in the language of your choice.

> For the most up-to-date information on supported languages, see [the Cloud Foundry docs](https://docs.cloudfoundry.org/cf-cli/getting-started.html#i18n).

To change the locale in use, you can run:

```
cf config --locale <LOCALE>
```

For example, you can change to German using:

```
cf config --locale de-DE
```

You can rerun `cf help` commands to see the effect.

Using a locale of `CLEAR` will remove any value set previously:

```
cf config --locale CLEAR
```

We will discuss more advanced CF CLI concepts towards the end of this course.