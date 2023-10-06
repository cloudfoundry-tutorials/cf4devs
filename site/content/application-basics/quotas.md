---
title: "Quotas"
layout: "docs"
weight: 9
---

Quotas are named sets of memory, service, and instance usage limits. They can be applied at the org level or the space level. Org quotas are mandatory, while space quotas are optional. Org-level quotas are shared across all spaces in that org.

Typically, Cloud Foundry operators will establish quotas for orgs, and OrgManagers will establish quotas for spaces. So while it's not crucial that developers know how to manage quotas, it is important you understand how to view the quotas for your orgs and spaces. After all, resource planning is a collaborative effort.

## Org Quotas

Let's take a look at what quota is on your current org:

```
cf org <org-name>
```

Once you've retrieved the quota, you can view its details:

```
cf org-quota <quota-name>
```

The output should show the resource limits on your org.

## Space Quotas

As mentioned above, quotas can be scoped at both the org and space level. Like org quotas, we can check what quota is applied on a space, by running 

```
cf space <space-name>
```

If a space doesn't have an associated quota, then this value will be empty in the `cf space` output. If you have a space quota set, then
 
```
cf space-quota <quota-name>
``` 

to see the details of that quota.

