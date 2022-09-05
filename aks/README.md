------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ Azure CLI -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

```bash
$ az login
$ az account show
$ az group list -o table 
$ az account list-locations -o table
$ az group create --name my-aks-rg --location northeurope 
```

```bash
$ az aks create -g my-aks-rg -n my-aks-cluster --generate-ssh-keys --node-count 2
$ az aks list -o table
```

```bash
$ az aks get-credentials -g my-aks-rg -n my-aks-cluster
```

Verify access:
```bash
$ kubectl get nodes
```

```bash
$ az aks show -n my-aks-cluster -g my-aks-rg -o table
```

Note that it also create another resource group (Node Resource Group) named `MC_my-aks-rg_my-aks-cluster_northeurope`

Cleanup
```bash
$ az aks delete -n my-aks-cluster -g my-aks-rg 
$ az group delete -g my-aks-rg 
```

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ Terraform -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

```bash
$ export SUBSCRIPTION_ID = '<SUBSCRIPTION_ID>' // get it via `az account list` (id property)
```

Create a service principal (In Azure Portal -> Azure AD -> App registrations)

```bash
$ az ad sp create-for-rbac --name "aks-sp" --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID"
```

Output:

```bash

{
  "appId": "c847a4e8-30f9-4767-9c32-c202946605d8",
  "displayName": "aks-sp",
  "password": "sK58Q~D5pMRMIS61DJ4kpMXjz3WIKibiCXyfoaNB",
  "tenant": "f3730dbf-6176-4a2e-93c0-f762af479d33"
}
```

Get it back (the password you cannot get it back)
```bash
$ az ad sp list --display-name aks-sp -o table
```

Before running `terraform apply` export these variables:

```bash
export ARM_CLIENT_ID=c847a4e8-30f9-4767-9c32-c202946605d8
export ARM_SUBSCRIPTION_ID=7ac2735b-bc31-4829-8923-57c346cd48ed
export ARM_TENANT_ID=f3730dbf-6176-4a2e-93c0-f762af479d33
export ARM_CLIENT_SECRET=sK58Q~D5pMRMIS61DJ4kpMXjz3WIKibiCXyfoaNB
```


```bash
$ terraform fmt
$ terraform validate
$ terraform apply
```

A `kubeconfig` file was created. Check connection:

```bash
$ kubectl get nodes --kubeconfig kubeconfig
```

After the Ingress Controller is provisioned, get the LoadBalancer external IP 

```bash
$ kubectl get svc -n ingress-nginx --kubeconfig kubeconfig
```

```bash
$ kubectl apply -f ./demo-app/aks-helloworld-one.yaml --namespace ingress-nginx --kubeconfig kubeconfig
$ kubectl apply -f ./demo-app/aks-helloworld-two.yaml --namespace ingress-nginx --kubeconfig kubeconfig
```

```bash
$ kubectl apply -f ./demo-app/hello-world-ingress.yaml --namespace ingress-nginx --kubeconfig kubeconfig
```

```bash
$ curl http://20.240.157.182/ | grep title
$ curl http://20.240.157.182/hello-world-two | grep title
```


References
- Quickstart: Create a Kubernetes cluster with Azure Kubernetes Service using Terraform: https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks#set-up-azure-storage-to-store-terraform-state
- Terraform examples: https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/kubernetes
- Deploying the NGINX Ingress Controller in an AKS cluster: https://docs.microsoft.com/en-us/azure/aks/ingress-basic?tabs=azure-cli
- Provision an AKS Cluster (Azure): https://learn.hashicorp.com/tutorials/terraform/aks
- Best practices AKS Setup: https://intercept.cloud/en/news/azure-kubernetes-cluster-set-up/