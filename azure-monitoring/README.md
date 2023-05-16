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
    apply -auto-approve
```

# Test

Run in cloud shell

```
#iKey="bc1e1cdf-d980-4c08-9459-0c1e2b59cab4";
iKey="2209a5a6-c7b8-4ab7-b4a7-291eead652a3";
#iKey="13b5e5db-930d-465f-82a9-09df7db3a81b";
#iKey="f0fd3b09-626f-441d-be9b-32f63a4f4b5b";
timeStamp=$(date -u +'%Y-%m-%d %H:%M:%S.%s%Z');
data='{
   "name": "Microsoft.ApplicationInsights.Event",
   "time": "'$timeStamp'",
   "iKey": "'$iKey'",
   "tags":{
      "ai.operation.name":  "POST traveler_updated",
      "ai.operation.id": "1328d445f4a63570e839095b1c6e71ac",
      "ai.operation.parentId": "c40f97f19b2c1eb9",
      "ai.cloud.role": "ScheduledJobs",
      "ai.cloud.roleInstance": "virtualServer01"
   },
   "data": {
      "baseType": "MessageData",
      "baseData": {
         "ver": 2,
         "message": "Simple Trace Log Message",
         "severityLevel": 2,
         "properties": {
            "x": "value x",
            "y": "value y",
            "z": "value z"
         }
      }
   }
}';
curl -d "$data" https://global.in.ai.monitor.azure.com/v2/track
```

kusto:
```
traces |
extend xDimension = tostring(customDimensions["x"])
```