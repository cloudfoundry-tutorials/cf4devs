---
title: "Application Security Groups"
layout: "docs"
weight: 10
---

Application Security Groups (ASGs) are a collection of egress rules that list protocols, ports, and IP address ranges where an app or task is allowed to connect to (where your app can reach out to). ASGs define 'allow' rules. When ASGs are applied to the same space or deployment, their order of evaluation is unimportant; ASGs are additive.

ASGs can only be created or updated by admins. However, as ASGs dictate the outbound connectivity allowed, it is important to understand them as a developer.

> Whenever application security groups are added, updated, or removed, you must restart your app for the changes to take effect.

## Staging and Running ASGs

Security groups can be applied globally - to all orgs and spaces - by assigning them to either the staging or running ASG set. ASGs in the staging set determine the egress allowed during app staging, while those in the running set do so for app and task runtime.

When apps and tasks begin staging, they need traffic rules permissive enough to allow them to pull dependencies from the network. A running app or task is likely to have fewer needs of this sort, so ASGs applied during staging are often more permissive than those applied during the running lifecycle.

To view the ASGs for staging:

```
cf staging-security-groups
```

And for running ASGs:

```
cf running-security-groups
```

Once you've retrieved the name of the ASG you want to inspect, you can view the details of those rules:

```
cf security-group <security-group-name>
```

This will output a JSON object similar to this:

```json
[
    {
      "protocol": "tcp",
      "destination": "0.0.0.0/0",
      "ports": "53"
    },
    {
      "protocol": "udp",
      "destination": "0.0.0.0/0",
      "ports": "53"
    }
]
```

The above example shows an ASG named `dns`, which is one of the two ASGs preconfigured in open-source installations of Cloud Foundry (commercial distributions may have different defaults). This example ASG permits egress on port 53 over TCP and UDP to any IP address.

The other default ASG, `public_networks`, has the effect of blocking outbound traffic to the following private IP address ranges by omitting them from the ranges that it does permit:

* 10.0.0.0 - 10.255.255.255
* 169.254.0.0 - 169.254.255.255
* 172.16.0.0 - 172.31.255.255
* 192.168.0.0 - 192.168.255.255

Of course, egress to these IP address ranges will be permitted if another ASG is created allowing egress to them.

## Space-scoped ASGs

It is also possible for admins to bind ASGs to a specific space. In such cases, the space-specific ASGs are combined with the platform ASGs to determine the rules for that space.

You will still need an admin to create ASGs that you want to apply to a particular space, but, once created, a Space Manager can bind the ASG to their space with the following command:

```
cf bind-security-group <security-group> <org> --space <space>
```

By default this will apply the ASG as a _running_ security group in the space. To instead set it as a staging security group use the `--lifecycle` flag.