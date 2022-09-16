```bash
$ terraform fmt
$ terraform validate
$ terraform plan
```

```bash
$ terraform apply
```

```bash
$ terraform output
kafka-fqdn = [
  "kafka-0-dpwolbsf.westeurope.cloudapp.azure.com",
  "kafka-1-dpwolbsf.westeurope.cloudapp.azure.com",
  "kafka-2-dpwolbsf.westeurope.cloudapp.azure.com",
]
resource_group_name = "rg-brave-deer"
tls_private_key = <sensitive>
zookeeper-fqdn = "zookeeper-dpwolbsf.westeurope.cloudapp.azure.com"
```

```bash
$ export RG=$(terraform output --raw resource_group_name)
```

```bash
$ az vm list -g $RG -o table
Name       ResourceGroup    Location    Zones
---------  ---------------  ----------  -------
kafka-0    rg-brave-deer    westeurope
kafka-1    rg-brave-deer    westeurope
kafka-2    rg-brave-deer    westeurope
zookeeper  rg-brave-deer    westeurope
```

```
$ az vm list-ip-addresses -g $RG -o table
VirtualMachine    PublicIPAddresses    PrivateIPAddresses
----------------  -------------------  --------------------
kafka-0           52.136.221.29        10.0.1.5
kafka-1           52.136.220.208       10.0.1.6
kafka-2           52.136.221.143       10.0.1.7
zookeeper         52.136.217.85        10.0.1.4
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