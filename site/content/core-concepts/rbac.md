---
title: "Role-based Access Control"
layout: "docs"
weight: 2
---

Cloud Foundry leverages Role-Based Access Control (RBAC) to restrict user actions that affect resources within the platform. Users can be assigned to roles globally (deployment-wide) or can be assigned to roles in specific orgs and spaces. Roles control what you can do and where you can do it.

## Global Roles

Users can be assigned global roles and capabilities that span an entire Cloud Foundry deployment. As a developer using Cloud Foundry, it is unlikely you will be assigned one of these roles.

* **Admin**: Allows a user to perform operational actions on all orgs and spaces.
* **Admin Read-Only**: Allows visibility of all orgs and spaces without the ability to modify resources.
* **Global Auditor**: Similar to the `Admin Read-Only` role, except that this role cannot see secrets such as environment variable content.

## Org Roles

Org roles grant user access at the org level.

* **OrgManager**: Can administer the org. OrgManagers can create/modify/delete spaces, org-level roles, domains, etc., in that org. 
* **OrgAuditor**: Have read-only access to the org.
* **BillingManager**: Billing managers can create and manage billing account and payment information associated with an org in Cloud Foundry instances that have deployed the billing engine.

You can see the users assigned to these roles for an org via:

```
cf org-users <ORG>
```

OrgManagers can manage users in your org with:

```
cf set-org-role
``` 

and

``` 
cf unset-org-role
```

## Space Roles

Space roles grant user access at the space level.

* **SpaceManager**: Space managers can administer roles for a space.
* **SpaceDeveloper**: Can manage apps, services, and routes in a space. A user must have the `SpaceDeveloper` role to push apps.
* **SpaceAuditor**: Space auditors have read-only access to a space.
* **Space Supporter**: Troubleshoot and debug apps and service bindings in a space.

You can see the users assigned to roles in a space with the command:

```
cf space-users <ORG> <SPACE>
```

Org roles do not cascade into spaces. For example, an `OrgManager` *cannot* deploy apps to spaces in their org. However, they can grant the `SpaceDeveloper` role to a user (including themselves) for a particular space.

SpaceManagers can manage users in your space with:

```
cf set-space-role
``` 

and

``` 
cf unset-space-role
```

You can also see all users assigned to org roles and space roles by running:

```
cf org-users <ORG> -a
```
