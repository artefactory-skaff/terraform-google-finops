This module Terraforms configurable BigQuery quotas and billing alerts on a GCP project.

## Pre-requisites

- [Install Terraform](install_terraform.md)
- [Log in to GCP with your default credentials](gcp_login.md)
- [Cloud Resource Manager API needs to be activated in your project](https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview)

### Required roles and permissions

####  On the project you want to deploy on:

- Broad roles that will work, but **not recommended** for service accounts or even people.
  - `roles/owner`
  - `roles/editor`
- Recommended roles to respect least privilege principle.
  - `roles/servicemanagement.serviceConsumer`
  - `roles/servicemanagement.quotaAdmin`
  - `roles/serviceusage.serviceUsageAdmin`
  - `roles/monitoring.notificationChannelEditor`
- Granular permissions required to build a custom role specific for this deployment.
  - `monitoring.alertPolicies.create`
  - `monitoring.alertPolicies.delete`
  - `monitoring.notificationChannels.create`
  - `monitoring.notificationChannels.delete`
  - `servicemanagement.services.bind`
  - `serviceusage.operations.get`
  - `serviceusage.quotas.update`
  - `serviceusage.services.enable`
  - `serviceusage.services.get`

####  On the billing account:
!!! info
    To deploy budget alerts, you will need permissions on the billing account linked with the project. This is not something that can be granted at the project level. It has to be granted on the Billing Account itself.

The principal used to deploy budget alerts will need to be `roles/billing.costsManager`

You will not need this role if you're only deploying quotas.

## Deployment
- [One-shot](one_shot_deployment.md)
- [Managed](continuous_deployment.md)