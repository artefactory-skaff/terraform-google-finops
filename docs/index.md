---
hide:
  - navigation
  - toc
---

This module Terraforms configurable BigQuery quotas and billing alerts on a GCP project. 

Use it as early as possible in your project to prevent cost runaway scenarios and establish a sound FinOps foundation for your project.

Deployment time: ~15 minutes.

---
[View the module in the Terraform registry](https://registry.terraform.io/modules/artefactory/finops/google/latest)

[View the module in GitHub](https://github.com/artefactory/terraform-google-finops)

---
## Pre-requisites

??? success "Install Terraform"

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
  

??? success "Log in to GCP with your default credentials"

    !!! warning 
        Look at the below commands outputs to make sure you're connecting to the right `PROJECT_ID`.
  
    ```console
    gcloud auth login
    
    [...]
    You are now logged in as [alexis.vialaret@artefact.com].
    Your current project is [PROJECT_ID]. You can change this setting by running:
    $ gcloud config set project PROJECT_ID
    ```
    
    ```console
    gcloud auth application-default login

    [...]
    Credentials saved to file: [/Users/alexis.vialaret/.config/gcloud/application_default_credentials.json]
    These credentials will be used by any library that requests Application Default Credentials (ADC).
    Quota project "PROJECT_ID" was added to ADC which can be used by Google client libraries for billing and quota. Note that some services may still bill the project owning the resource.
    ```

??? success "Activate the Cloud Resource Manager API"
    [Go to the Google cloud console and activate the API](https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview)

??? success "Required roles and permissions"

    **On the project you want to deploy on:**
    
    - Broad roles that will work, but **not recommended** for service accounts or even people.
      - `roles/owner`
      - `roles/editor`
    - Recommended roles to respect the least privilege principle.
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
    
    **On the billing account:**
    !!! info
        To deploy budget alerts, you will need permissions on the billing account linked with the project. This is not something that can be granted at the project level. It has to be granted on the Billing Account itself.
    
    The principal used to deploy budget alerts will need to be `roles/billing.costsManager`
    
    You will not need this role if you're only deploying quotas.

---
## Deploy the FinOps module on GCP

=== "One-shot deployment"

    !!! note ""
        This mode of deployment is quicker and easier. It's suitable for projects where the infrastructure is not meant to be managed by Terraform in the long run. Otherwise, prefer the continuous deployment workflow.

    Download the standalone `main.tf`:
    ```console
    curl -O https://raw.githubusercontent.com/artefactory/terraform-google-finops/main/examples/standalone/main.tf 

      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100  3066  100  3066    0     0  11883      0 --:--:-- --:--:-- --:--:-- 11883
    ```
    
    Initialize Terraform:
    ```console
    terraform init
    ```
    ??? info "Output"
        ```console
        Initializing the backend...
        Initializing modules...
        Downloading registry.terraform.io/artefactory/finops/google 0.1.1 for finops...
        - finops in .terraform/modules/finops
        
        Initializing provider plugins...
        - Finding latest version of hashicorp/google...
        - Finding latest version of hashicorp/google-beta...
        - Installing hashicorp/google v4.59.0...
        - Installed hashicorp/google v4.59.0 (signed by HashiCorp)
        - Installing hashicorp/google-beta v4.59.0...
        - Installed hashicorp/google-beta v4.59.0 (signed by HashiCorp)
        
        Terraform has created a lock file .terraform.lock.hcl to record the provider
        selections it made above. Include this file in your version control repository
        so that Terraform can guarantee to make the same selections by default when
        you run "terraform init" in the future.
        
        Terraform has been successfully initialized!
        
        You may now begin working with Terraform. Try running "terraform plan" to see
        any changes that are required for your infrastructure. All Terraform commands
        should now work.
        
        If you ever set or change modules or backend configuration for Terraform,
        rerun this command to reinitialize your working directory. If you forget, other
        commands will detect it and remind you to do so if necessary.
        ```
    
    Open `main.tf` and uncomment the quotas, budgets, and alerts that you want.
    
    Apply the infrastructure configuration:
    ```console
    terraform apply
    ```
    ??? info "Output"
        ```console
    
        [...]
          # module.finops.google_service_usage_consumer_quota_override.bigquery_query_user will be created
          + resource "google_service_usage_consumer_quota_override" "bigquery_query_user" {
              + force          = true
              + id             = (known after apply)
              + limit          = "%2Fd%2Fproject%2Fuser"
              + metric         = "bigquery.googleapis.com%2Fquota%2Fquery%2Fusage"
              + name           = (known after apply)
              + override_value = "10485760"
              + project        = "PROJECT_ID"
              + service        = "bigquery.googleapis.com"
            }
        
        Plan: 7 to add, 0 to change, 0 to destroy.
        
        Do you want to perform these actions?
          Terraform will perform the actions described above.
          Only 'yes' will be accepted to approve.
        
          Enter a value: yes
        [...]
        Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
        ```
    
    Clean up files created by Terraform:
    ```console
    rm -rf main.tf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup
    ```

=== "Managed deployment"
    
    !!! note ""
        To keep your infra code clean and concerns separated, we recommend adding the finops module in a standalone file
    
    ```console
    curl -o finops.tf https://raw.githubusercontent.com/artefactory/terraform-google-finops/main/examples/standalone/main.tf
    ```
    ```console
    .
    ├── finops.tf ⬅
    ├── main.tf
    ├── outputs.tf
    └── variables.tf
    ```
    ```console
    terraform init
    ```
    
    [The Terraform registry entry has the full module documentation and examples.](https://registry.terraform.io/modules/artefactory/finops/google/latest)