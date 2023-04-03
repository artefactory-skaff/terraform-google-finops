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

Download the standalone `main.tf`:
```shell
$ curl -O https://raw.githubusercontent.com/artefactory/terraform-google-finops/main/examples/standalone/main.tf 

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3066  100  3066    0     0  11883      0 --:--:-- --:--:-- --:--:-- 11883
```
Initialize Terraform:
```shell
$ terraform init

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
```shell
$ terraform apply

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

  Enter a value:
```

## Clean-up
