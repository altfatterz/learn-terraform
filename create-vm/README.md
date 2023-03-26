```bash
$ az version
{
  "azure-cli": "2.46.0",
  "azure-cli-core": "2.46.0",
  "azure-cli-telemetry": "1.0.8",
  "extensions": {
    "account": "0.2.2",
    "spring-cloud": "3.0.1"
  }
}
```

```bash
$ az login
$ az account show
```

Two ways to authenticate Terraform to Azure

1. Microsoft account
2. Service account (better in CI/CD)

Create a `service principal` and configure its access to Azure resources.
A Service Principal is an application within Azure Active Directory with the authentication tokens Terraform needs to perform actions on your behalf.

```bash
$ az ad sp create-for-rbac --name="terraform-create-vm" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

Creating 'Contributor' role assignment under scope '/subscriptions/7ac2735b-bc31-4829-8923-57c346cd48ed'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli

```json
{
  "appId": "",
  "displayName": "",
  "password": "",
  "tenant": ""
}
```

In Azure Portal you can view this resource in `App registrations`

Return it back:
```bash
$ az ad sp list --all -o table | grep terraform
$ az ad sp list --display-name terraform-create-vm
```

To pull down the provider plugins you need to run this command:

```bash
$ terraform init
```

Useful commands:

```bash
$ terraform fmt
$ terraform validate
$ terraform plan -out tfplan
```

Apply changes:

```bash
$ terraform apply tfplan
```

Inspect the current state:

```bash
$ terraform show
$ terraform state list
```

Query the output:

```bash
$ terraform output
```

```bash
$ terraform output -raw tls_private_key > key.pem
$ chmod 400 key.pem
$ terraform output public_ip_address
$ ssh -i key.pem ubuntu@<public_ip_address>
$ ubuntu@myVM:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 18.04.6 LTS
Release:	18.04
Codename:	bionic
```

List VM names:

```bash
$ az vm list -g $(terraform output --raw resource_group_name) -o table
```

List RG names:

```bash
$ az group list -o table
```

Apply overriding the default resource group name.

```bash
$ terraform apply -var "resource_group_name=myNewResourceGroupName"
```

### Destroy Infrastructure

```bash
$ terraform destroy
```


Resources:
1. Quickstart: https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure
2. Hashicorp: https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started


