This module Terraforms configurable BigQuery quotas and billing alerts on a GCP project. 

Use it as early in your project as possible to prevent cost runaway scenarios and establish a sound FinOps foundation for your project.

Deployment time: ~15 minutes.

---
[View the module in the Terraform registry](https://registry.terraform.io/modules/artefactory/finops/google/latest)

[View the module in GitHub](https://github.com/artefactory/terraform-google-finops)

---
## Pre-requisites

??? note "Install Terraform"

    !!! note
        Tested for Terraform >= v1.4.0

    Use tfswitch to easily install and manage Terraform
    ```console
    $ brew install warrensbox/tap/tfswitch
    
    [...]
    ==> Summary
    🍺  /opt/homebrew/Cellar/tfswitch/0.13.1308: 6 files, 10.1MB, built in 3 seconds
    ==> Running `brew cleanup tfswitch`...
    ```
    ```console
    $ tfswitch
    
    ✔ 1.4.2
    Downloading to: /Users/alexis.vialaret/.terraform.versions
    20588400 bytes downloaded
    Switched terraform to version "1.4.2" 
    ```
  

??? note "Log in to GCP with your default credentials"

    !!! warning 
        Look at the below commands outputs to make sure you're connecting to the right `PROJECT_ID`.
  
    ```console
    gcloud auth login
    ```
    ??? info "Output"
        ```console
        [...]
        You are now logged in as [alexis.vialaret@artefact.com].
        Your current project is [PROJECT_ID]. You can change this setting by running:
        $ gcloud config set project PROJECT_ID
        ```
    
    ```console
    gcloud auth application-default login
    ```
    ??? info "Output"
        ```console
        [...]
        Credentials saved to file: [/Users/alexis.vialaret/.config/gcloud/application_default_credentials.json]
        
        These credentials will be used by any library that requests Application Default Credentials (ADC).
        
        Quota project "PROJECT_ID" was added to ADC which can be used by Google client libraries for billing and quota. Note that some services may still bill the project owning the resource.
        ```
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