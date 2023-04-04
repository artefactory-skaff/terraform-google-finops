This mode of deployment is quicker and easier. It's suitable for projects where the infrastructure is not meant to be managed by Terraform in the long run. [Otherwise, prefer the continuous deployment workflow.](continuous_deployment.md)

!!! warning
    [Make sure you have fulfilled all the pre-requisites](index.md)

## Deploy the module
Download the standalone `main.tf`:
```console
curl -O https://raw.githubusercontent.com/artefactory/terraform-google-finops/main/examples/standalone/main.tf 
```
??? info "Output"
    ```console
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

## Clean-up

Clean up files created by Terraform:
```console
rm -rf main.tf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup
```