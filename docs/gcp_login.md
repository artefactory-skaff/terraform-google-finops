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