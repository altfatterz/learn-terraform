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

7ac2735b-bc31-4829-8923-57c346cd48ed


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

Get it back
```bash
$ az ad sp list -sp aks-sp
```


References
- Best practices AKS Setup: https://intercept.cloud/en/news/azure-kubernetes-cluster-set-up/