#### Compose variable files

For example:

```bash
ARM_CLIENT_ID="531adb66-98a5-4e6b-b407-b1961a2794e1";
ARM_CLIENT_SECRET="xxxx";
ARM_SUBSCRIPTION_ID="d7c7a3af-f74f-4007-845c-dcacef601c53";
ARM_TENANT_ID="8b87af7d-8647-4dc7-8df4-5f69a2011bb5";
```

# Deploy Using Linux

```bash
rm -rf .terraform.tfstate.lock.info
rm -rf .terraform
rm -f terraform.tfstate
rm -f terraform.tfstate.backup
rm -f .terraform.lock.hcl
docker run --rm -v $(pwd):/workplace -w /workplace hashicorp/terraform:light init
docker run --rm -v $(pwd):/workplace -w /workplace \
    -e TF_VAR_ARM_CLIENT_ID=$ARM_CLIENT_ID \
    -e TF_VAR_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
    -e TF_VAR_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
    -e TF_VAR_ARM_TENANT_ID=$ARM_TENANT_ID \
    hashicorp/terraform:light \
    plan
```
