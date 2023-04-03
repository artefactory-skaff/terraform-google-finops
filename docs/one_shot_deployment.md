This mode of deployment is quicker and easier. It's suitable for project where the infrastructure is not meant to be managed by Terraform in the long run.

## Install Terraform

Use tfswitch to easily install and manage Terraform
```shell
$ brew install warrensbox/tap/tfswitch

[...]
==> Summary
🍺  /opt/homebrew/Cellar/tfswitch/0.13.1308: 6 files, 10.1MB, built in 3 seconds
==> Running `brew cleanup tfswitch`...
```
```shell
$ tfswitch

✔ 1.4.2
Downloading to: /Users/alexis.vialaret/.terraform.versions
20588400 bytes downloaded
Switched terraform to version "1.4.2" 
```

## Log in to your GCP project
!!! warning 
    Look at the below commands outputs to make sure you're connecting to the right `PROJECT_ID`.
```shell
$ gcloud auth login

[...]
You are now logged in as [alexis.vialaret@artefact.com].
Your current project is [PROJECT_ID]. You can change this setting by running:
  $ gcloud config set project PROJECT_ID
```
```shell
$ gcloud auth application-default login

[...]
Credentials saved to file: [/Users/alexis.vialaret/.config/gcloud/application_default_credentials.json]

These credentials will be used by any library that requests Application Default Credentials (ADC).

Quota project "PROJECT_ID" was added to ADC which can be used by Google client libraries for billing and quota. Note that some services may still bill the project owning the resource.
```

## Deploy the module

Create a `main.tf` file with the following contents:
??? abstract "main.tf"

    ```hcl
    module "finops" {
      source  = "artefactory/finops/google"
      version = "~> 0.1"
    
      budgets = {
        billing_account_id = "ABCDEF-ABCDEF-ABCDEF"
    
        # Configure a $200 USD budget for the project with alerts at 80% actual consumption and 200% forecasted consumption.
        absolute_amount = {
          amount = 200
          alerts = {
            notification_channels          = [google_monitoring_notification_channel.basic.id]
    
            # Send an alert when 80% of the month's budget has been consumed.
            current_threshold_ratio        = 0.8
    
            # Send an alert when the forecasted spend at the end of the period is greater than 200% of the budget.
            forecasted_threshold_ratio     = 2
          }
        }
    
        # Configure a budget based on the last month's spend.
        relative_amount = {
          alerts = {
            notification_channels          = [google_monitoring_notification_channel.basic.id]
    
            # Send an alert when the spend for this month has increased more than 20% compared to last month.
            current_threshold_ratio        = 1.2
          }
        }
      }
    }
    ```

## Clean-up
