!!! warning
    [Make sure you have fulfilled all the pre-requisites](index.md)

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