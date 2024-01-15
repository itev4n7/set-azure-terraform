## set-azure-terraform

Terraform scripts for [set-azure-project](https://github.com/itev4n7/set-azure-project)

**Note**: You need to pre setup **Container registry** and **Storage account** service by your own.
Into **Container registry** you need to push a docker image, in **Storage account** create containers for terraform backend.
Also for **Function app** you need to upload the app archive that will be hosted there.

Before commands:
- ``az login``

To push image into container registry using podman (you need to do it in **set-azure-project**):
- ``az acr login --name <container_name> --expose-token --output tsv --query accessToken``
- ``podman login <container_name>.azurecr.io -u "00000000-0000-0000-0000-000000000000" -p <copy_token_above>``
- ``podman tag set-azure-project <container_name>.azurecr.io/set-azure-project:latest``
- ``podman push <container_name>.azurecr.io/set-azure-project:latest``

To publish function app (you need to do it in **set-azure-project** and in exact function app folder):
- ``func azure functionapp publish <function_app_name>``

To create infrastructure (before run move to desired environment folder):
- ``terraform init``
- ``terraform plan -var-file="terraform.tfvars"``
- ``terraform apply -var-file="terraform.tfvars"``

To destroy infrastructure (before run move to desired environment folder):
- ``terraform destroy``
