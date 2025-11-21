```bash
$ terraform fmt
$ terraform validate
$ terraform plan
```

```bash
$ terraform apply

Outputs:

fqdn = [
  "dsnktmsu-0.westeurope.cloudapp.azure.com",
  "dsnktmsu-1.westeurope.cloudapp.azure.com",
]
resource_group_name = "rg-superb-beagle"
tls_private_key = <sensitive>
```

```bash
$ export RG=$(terraform output --raw resource_group_name)
```

```bash
$ az vm list -g $RG -o table
$ az vm list-ip-addresses -g $RG -o table
```

```bash
$ terraform output -raw tls_private_key > key.pem
$ chmod 400 key.pem
$ ssh -i key.pem ubuntu@<fqdn>
```

```bash
$ ssh -i key.pem ubuntu@kafka0.westeurope.cloudapp.azure.com
```

```bash
$ terraform show
$ terraform state list
```

```bash
$ terraform destroy
$ az group delete --name $RG
$ az group list -o table
```