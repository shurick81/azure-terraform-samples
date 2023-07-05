Run in WSL, Linux or Mac:

```bash
sudo hwclock -s;
docker run -it --rm -v $(pwd):/root -w /root mcr.microsoft.com/azure-cli:2.48.1;
```

Copy paste variables in the container session, then run the following

```bash
wget https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip -O /home/terraform_1.4.6_linux_amd64.zip;
unzip /home/terraform_1.4.6_linux_amd64.zip -d /home;
mv -f /home/terraform /usr/bin/terraform;

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl";
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256";
echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c;
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl;

az login --tenant $ARM_TENANT_ID

terraform -chdir=aks-persistent-volumes init;
terraform -chdir=aks-persistent-volumes plan;
terraform -chdir=aks-persistent-volumes apply -auto-approve;
```

```bash
az aks get-credentials --subscription $ARM_SUBSCRIPTION_ID_00 --resource-group aks-persistent-volumes-samples-common-00 --name common00 --overwrite-existing;
#az aks get-upgrades --subscription $ARM_SUBSCRIPTION_ID_00 --resource-group aks-persistent-volumes-samples-common-00 --name common00 --output table;
STORAGE_KEY=$(az storage account keys list --subscription $ARM_SUBSCRIPTION_ID_01 --resource-group aks-persistent-volumes-samples-common-00 --account-name rillionstwe00 --query "[0].value" -o tsv);
kubectl create namespace empty-class-ns;
kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=rillionstwe00 --from-literal=azurestorageaccountkey=$STORAGE_KEY --namespace="empty-class-ns";
kubectl apply -f aks-persistent-volumes/iis-example-empty-class.yml;
#kubectl apply -f aks-persistent-volumes/iis-example-csi-file-share.yml;
kubectl get services --all-namespaces;
kubectl get pv --all-namespaces -o yaml;
kubectl get pods --all-namespaces;
kubectl exec -it --namespace empty-class-ns iis-2022-5c69bf4cbd-lvx48 -- powershell -c "Get-Content C:\inetpub\wwwroot\iisstart.htm";
#az aks get-upgrades --subscription $ARM_SUBSCRIPTION_ID_00 --resource-group aks-persistent-volumes-samples-common-00 --name common00 --output table;
```

Check External IP

```bash
curl http://20.76.115.173
```

Migrate to the new volumes

```bash
kubectl scale deployment -n empty-class-ns --replicas 0 iis-2022;
kubectl delete pvc empty-class-claim --namespace  empty-class-ns;
kubectl delete pv empty-class --namespace  empty-class-ns;
kubectl apply -f aks-persistent-volumes/iis-example-empty-class-migrated-to-csi.yml;
```

Check External IP

```bash
curl http://20.23.37.7
```

```bash
terraform -chdir=aks-persistent-volumes destroy -auto-approve;
```
