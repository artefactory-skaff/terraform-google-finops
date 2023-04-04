## Install Terraform

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

## Log in to your GCP project
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

## Add the module to your infrastructure deployment

!!! note
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