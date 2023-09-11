Run in WSL, Linux or Mac:

```bash
sudo hwclock -s;
docker run -it --rm -v $(pwd):/root -w /root mcr.microsoft.com/azure-cli:2.52.0;
```

Copy paste variables in the container session, then run the following

```bash
wget https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip -O /home/terraform_1.5.6_linux_amd64.zip;
unzip /home/terraform_1.5.6_linux_amd64.zip -d /home;
mv -f /home/terraform /usr/bin/terraform;

#kubectl_version=$(curl -L -s https://dl.k8s.io/release/stable.txt);
kubectl_version="v1.28.1";
curl -LO "https://dl.k8s.io/release/$kubectl_version/bin/linux/amd64/kubectl";
curl -LO "https://dl.k8s.io/$kubectl_version/bin/linux/amd64/kubectl.sha256";
echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c;
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl;

az login --tenant $ARM_TENANT_ID

terraform -chdir=aks-smb-multiple-connection-issue init;
terraform -chdir=aks-smb-multiple-connection-issue plan;
terraform -chdir=aks-smb-multiple-connection-issue apply -auto-approve;
```

```bash
az aks get-credentials --subscription $ARM_SUBSCRIPTION_ID_00 --resource-group aks-smb-multiple-connection-issue-common-00 --name common00 --overwrite-existing;
for i in {0..49}; do
  kubectl create namespace csi-file-share-instance$i-ns;
done;
for i in {0..49}; do
  STORAGE_KEY=$(az storage account keys list --subscription $ARM_SUBSCRIPTION_ID_01 --resource-group aks-smb-multiple-connection-issue-common-00 --account-name rillioninstwe$i --query "[0].value" -o tsv);
  kubectl create secret generic azure-secret --namespace csi-file-share-instance$i-ns --from-literal azurestorageaccountname=rillioninstwe$i --from-literal azurestorageaccountkey=$STORAGE_KEY;
done;
for i in {0..49}; do
  cat aks-smb-multiple-connection-issue/kubernetes.yml | sed "s/{{INSTANCE_ID}}/$i/g" | kubectl apply -f -;
done;
sleep 120;
kubectl get pods --all-namespaces --field-selector=metadata.namespace!=kube-system;
```

Rescale deployments after some time:

```bash
for i in {0..24}; do
  kubectl scale deployment -n csi-file-share-instance$i-ns iis-2022-component-00 --replicas 0
  kubectl scale deployment -n csi-file-share-instance$i-ns iis-2022-component-01 --replicas 0
  sleep 20;
done;
for i in {0..24}; do
  cat aks-smb-multiple-connection-issue/kubernetes.yml | sed "s/{{INSTANCE_ID}}/$i/g" | kubectl apply -f -;
  sleep 20;
done;
kubectl get pods --all-namespaces --field-selector=metadata.namespace!=kube-system;
```

# Recover/Cleanup

```bash
for i in {0..49}; do
  kubectl scale deployment -n csi-file-share-instance$i-ns iis-2022-component-00 --replicas 0
  kubectl scale deployment -n csi-file-share-instance$i-ns iis-2022-component-01 --replicas 0
done;
for i in {0..49}; do
  kubectl delete pvc -n csi-file-share-instance$i-ns csi-file-share-00-claim
  kubectl delete pvc -n csi-file-share-instance$i-ns csi-file-share-01-claim
  kubectl delete pvc -n csi-file-share-instance$i-ns csi-file-share-02-claim
  kubectl delete pv csi-file-share-instance$i-directory00
  kubectl delete pv csi-file-share-instance$i-directory01
  kubectl delete pv csi-file-share-instance$i-directory02
done;
terraform -chdir=aks-smb-multiple-connection-issue destroy -auto-approve;
terraform -chdir=aks-smb-multiple-connection-issue destroy --target azurerm_kubernetes_cluster.common00 -auto-approve;
terraform -chdir=aks-smb-multiple-connection-issue taint azurerm_kubernetes_cluster.common00
```
