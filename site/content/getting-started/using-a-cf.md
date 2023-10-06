---
title: "Using a CF"
layout: "docs"
weight: 2
---

The `cf` CLI is used to interact with any Cloud Foundry instance. It makes [RESTful](https://www.codecademy.com/articles/what-is-rest) calls to the CF API endpoint of the particular instance you are using.

## Setting the Endpoint

Before you interact with a Cloud Foundry instance using the `cf` CLI, you need set the API endpoint. When you set an API endpoint, you are selecting an instance of Cloud Foundry to use. You may hear some vendors refer to deployments as "foundations" or "instances", which mean the same thing. They are a running Cloud Foundry.

You can set the API endpoint either with the `cf api` command or as part of the `cf login` command (you will see this below). Go ahead and set your API endpoint using:

```
cf api <API_ENDPOINT>
```

You should be able to see the endpoint you set by running:

```
cf api
```

## Authentication

After setting the API endpoint, you need to authenticate with the Cloud Foundry instance you are using. There are numerous options for authentication (used in different circumstances), but for now, we will interactively authenticate using `cf login`.

The `cf login` command has features and flags (view these by running `cf login --help`). The options allow you to authenticate interactively or in non-interactive mode.  The `-a` flag, is used to specify the API endpoint when logging in (rather than using the `cf api` command separately).

> Be careful when using non-interactive authentication, as credentials can end up in your terminal history.

### Interactive Terminal Login

To authenticate interactively in the terminal, run `cf login` without any flags. The CLI will prompt you to provide input. In this mode, your sensitive credentials are *not* stored in the command shell history. If you scroll through the command shell history in your terminal using the up-arrow key, you will see the `cf login` command but will not see your username or password.

### Interactive Browser Login

The `cf login` command also supports interactive login through your browser via the `-sso` (single sign-on) flag. Interactive browser login works well with browser-integrated password managers like 1Password, LastPass, or KeePass. Because you are authenticating via a browser, you have mitigated the risk of your password ending up in your shell history.

You can login interactively via:

```
cf login --sso
```

The CLI will output a URL. Copy and paste this in a browser, and authenticate in exchange for a passcode. You can copy and paste the passcode provided into the terminal window to complete the authentication flow.

> CFCD Exam Tip: The one-time passcode flow requires you to open pages in a browser. For this reason, you should **not** use `cf login --sso` in the exam as it may take you to a non-approved URL.

### Logging Out

When you authenticate with Cloud Foundry, the CLI caches a token locally. When you make requests (like pushing an app), the CLI includes this token in each request. Therefore you do not have to re-authenticate on every request and continue to work until your token expires (and cannot be refreshed). At this time, you would need to re-authenticate. However, this also means you need to be mindful to log out when appropriate to ensure a malicious actor does not gain access to your Cloud Foundry.

If you run `cf target`, you will see that you are authenticated. You can then log out using:

```
cf logout
```

If you re-run `cf target`, you will see you are no longer logged in.