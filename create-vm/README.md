https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started

```bash
$ az login
$ az account show
```

Create a service principal and configure its access to Azure resources.
A Service Principal is an application within Azure Active Directory with the authentication tokens Terraform needs to perform actions on your behalf.

```bash
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

Creating 'Contributor' role assignment under scope '/subscriptions/7ac2735b-bc31-4829-8923-57c346cd48ed'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "",
  "displayName": "",
  "password": "",
  "tenant": ""
}

Return it back:

```bash
$ a --display-name <display-name>
```

Useful commands:

```bash
$ terraform fmt
$ terraform validate
$ terraform plan
```

Apply changes:

```bash
$ terraform apply
```

Inspect the current state:

```bash
$ terraform show
$ terraform state list
```

Destroy Infrastructure

```bash
$ terraform destroy
```

Apply overriding the default resource group name.

```bash
$ terraform apply -var "resource_group_name=myNewResourceGroupName"
```

Query the output:

```bash
$ terraform output
```

```bash
$ terraform output -raw tls_private_key > key.pem
$ chmod 400 key.pem
$ terraform output public_ip_address
$ ssh -i id_rsa azureuser@<public_ip_address>
$ azureuser@myVm:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.4 LTS
Release:	20.04
Codename:	focal
```


Resources:
1. Confluent Platform on Azure: https://github.com/osodevops/terraform-azure-confluent-platform
2. Quickstart: https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure


