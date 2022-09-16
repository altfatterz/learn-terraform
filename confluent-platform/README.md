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
control-center-fqdn = "control-center-dpwolbsf.westeurope.cloudapp.azure.com"
kafka-fqdn = [
  "kafka-0-dpwolbsf.westeurope.cloudapp.azure.com",
  "kafka-1-dpwolbsf.westeurope.cloudapp.azure.com",
  "kafka-2-dpwolbsf.westeurope.cloudapp.azure.com",
]
platform-components-fqdn = "platform-components-dpwolbsf.westeurope.cloudapp.azure.com"
resource_group_name = "rg-brave-deer"
tls_private_key = <sensitive>
zookeeper-fqdn = "zookeeper-dpwolbsf.westeurope.cloudapp.azure.com"
```

```bash
$ export RG=$(terraform output --raw resource_group_name)
```

```bash
$ az vm list -g $RG -o table
Name                 ResourceGroup    Location    Zones
-------------------  ---------------  ----------  -------
control-center       rg-brave-deer    westeurope
kafka-0              rg-brave-deer    westeurope
kafka-1              rg-brave-deer    westeurope
kafka-2              rg-brave-deer    westeurope
platform-components  rg-brave-deer    westeurope
zookeeper            rg-brave-deer    westeurope
```

```
$ az vm list-ip-addresses -g $RG -o table
VirtualMachine       PublicIPAddresses    PrivateIPAddresses
-------------------  -------------------  --------------------
control-center       20.105.252.162       10.0.1.4
kafka-0              20.105.253.94        10.0.1.8
kafka-1              20.105.253.91        10.0.1.6
kafka-2              20.105.253.106       10.0.1.9
platform-components  20.105.253.69        10.0.1.5
zookeeper            20.105.253.86        10.0.1.7
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