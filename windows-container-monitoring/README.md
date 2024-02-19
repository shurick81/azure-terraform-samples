Run in WSL, Linux or Mac:

```bash
sudo hwclock -s;
docker run -it --rm -v $(pwd):/root -w /root mcr.microsoft.com/azure-cli:2.57.0;
```

Copy paste variables in the container session, then run the following

```bash
wget https://releases.hashicorp.com/terraform/1.7.3/terraform_1.7.3_linux_amd64.zip -O /home/terraform_1.7.3_linux_amd64.zip;
unzip /home/terraform_1.7.3_linux_amd64.zip -d /home;
mv -f /home/terraform /usr/bin/terraform;

az aks install-cli

az login --tenant $ARM_TENANT_ID
TF_VAR_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID;

terraform -chdir=windows-container-monitoring init;
terraform -chdir=windows-container-monitoring plan;
terraform -chdir=windows-container-monitoring apply -auto-approve;
```

```bash
az aks get-credentials --subscription $ARM_SUBSCRIPTION_ID --resource-group windows-container-monitoring-samples-common-00 --name common00 --overwrite-existing;
kubectl apply -f windows-container-monitoring/kubernetes/resources.yaml;
kubectl get services --all-namespaces;
```

Check External IP

```bash
wget -qO- http://4.231.65.38
kubectl exec -n monitoring-test-00 svc/iis-20022-component-00 -- powershell -c "New-EventLog -LogName Application -Source MyApp";
kubectl exec -n monitoring-test-00 svc/iis-20022-component-00 -- powershell -c "Write-EventLog -LogName Application -Source MyApp -EventID 3001 -EntryType Error -Message TestMessage";
kubectl logs -n monitoring-test-00 svc/iis-20022-component-00 --follow;
```

```bash
terraform -chdir=windows-container-monitoring destroy -auto-approve;
```
