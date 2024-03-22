---
title: "Sidecars"
layout: "docs"
weight: 4
---

You can run extra processes in the same container as your app. These processes are called sidecars.

When you provide a sidecar for your app, Cloud Foundry packages the code and config it needs to run the sidecar process and the app process in the same droplet, and deploys this droplet in a single container.

> Note: Each process within the container has its own health check. Sidecar processes can only use PID-based health checks.

## Why use Sidecars?

Sidecars are often used for processes that depend on each other, or that must run in the same container. For example, sidecars can be useful for processes that:
* Communicate over a Unix socket or through localhost
* Share the same filesystem
* Need to be scaled and placed together
* Must have fast interprocess communication

## Limitations

Co-locating processes in this way also introduces additional risks and limitations:

* **Co-dependent crashing** - if an app has one or more sidecars they are entirely co-dependent. If one process crashes, CF will kill the other and recreate it.
* **Scaling** - all of the container's resources are shared, and therefore co-located processes are scaled together with the main process.
* **Start/Stop order undefined** - you cannot control the order in which CF starts and stops app processes and their sidecars.
* **Health checks for sidecars** - sidecars are limited to PID-based health checks.

## Pushing

Sidecar processes can be defined in your app manifest via the `sidecars` block. The example below shows an app with multiple sidecar processes.

```
---
applications:
- name: my-app
  sidecars:
   - name: authenticator
     process_types: [ 'web', 'worker' ]
     command: bundle exec run-authenticator
   - name: performance monitor
     process_types: [ 'web' ]
     command: bundle exec run-performance-monitor
```

### Sidecars Pushed with Custom Buildpacks

Alternatively, a custom buildpack can specify sidecar processes by including a `launch.yml` file at its root. This file provides the details of the sidecar process.

If you are interested in learning more about custom sidecar buildpacks and the `launch.yml` file, take a look at the [Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/sidecar-buildpacks.html).

## Try it

Let's try pushing an app with a sidecar process.

We'll be pushing a simple Ruby app named `sidecar-dependent-app` with a `/config` endpoint. Hitting this endpoint will cause the app to call the sidecar and then print out the response. The sidecar is a Go process (named `config-server-sidecar`) that provides apps with config over its `/config` endpoint. It only accepts connections over localhost on the `CONFIG_SERVER_PORT`. Therefore, the processes must be co-located so that they share the same network space.

The sidecar process is configured in the app manifest:

```
applications:
- name: sidecar-dependent-app
  command: bundle exec rackup config.ru -p $PORT
  disk_quota: 256M
  instances: 1
  memory: 128M
  env:
    CONFIG_SERVER_PORT: 8082
  sidecars:
  - name: config-server
    process_types:
    - web
    command: './config-server'
```
The sidecar is included in the codebase as a binary. The `CONFIG_SERVER_PORT` environment variable is provided so that the sidecar knows which port to listen on and the app knows which port to connect to. The sidecar is also assigned to the app’s main `web` process, and given a name and start command.

We can deploy our app with: 

```
cf push --random-route \
    -b https://github.com/cloudfoundry/ruby-buildpack#v1.8.61 \
    -s cflinuxfs3
```

### View the Processes Running in the Container
Now that our app is up and running, we can SSH into the container to view the running processes with `cf ssh`
```
cf ssh sidecar-dependent-app
```
```
ps aux
```

You should see output similar to this:
```
vcap@f00949bd-6601-4731-6f7e-e859:~$ ps aux
USER    PID %CPU %MEM    VSZ      RSS   TTY   STAT   START TIME  COMMAND
root      1 0.0  0.0     1120     0     ?     S      22:17 0:00  /tmp/garden-init
vcap      7 0.0  0.0     106716   4508  ?     S      22:17 0:00  ./config-server
vcap     13 0.0  0.1     519688   35412 ?     S      22:17 0:00  /home/vcap/deps/0/vendor_bundle/ruby/2.4.0/bin/rackup config.ru -p 8080
vcap     24 0.0  0.0     116344   10792 ?     S      22:17 0:00  /tmp/lifecycle/diego-sshd --allowedKeyExchanges= --address=0.0.0.0:2222 --allowUnauthenticatedClients=false --inhe
root     82 0.0  0.0     108012   4548  ?     S      22:17 0:00  /etc/cf-assets/healthcheck/healthcheck -port=8080 -timeout=1000ms -liveness-interval=30s
vcap    215 0.3  0.0     70376    3756  pts/0 S      23:12 0:00  /bin/bash
vcap    227 0.0  0.0     86268    3116  pts/0 R      23:12 0:00  ps aux
```

The output shows both the sidecar `config-server` process and the main app `rackup` process.

### View the Web URL

In a browser we can navigate to the `/config` endpoint of the `sidecar-dependent-app`. Retrieve the route for your app using `cf app` and open the `/config` endpoint in your browser. For example:
```
https://sidecar-dependent-app.example.com/config
```

You should see the Scope and Password information displayed inside a JSON object. This is the config that the app has retrieved from the `config-server` sidecar.


### Sidecar Logs

Start streaming the logs for the app in a terminal window.
```
cf logs sidecar-dependent-app
```
Now refresh your browser window a few times. You should see the log stream in your terminal starts to display the logs for both the app and sidecar processes. Keep streaming the logs for the time being.

### Killing the sidecar process

We can go one step further and open another terminal window to SSH into the app container and kill the `config-server` process.
```
cf ssh sidecar-dependent-app
```
```
kill -9 $(pgrep config-server)
```
Take another look at the window where you're streaming the logs, and you should see the `config-server` crash and the container then being recreated.

## Tidy up
You can now go ahead and delete the `sidecar-dependent-app` deployment, we won't be reusing it in other sections.

