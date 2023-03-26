
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


# Ansible

```bash
$ ansible-galaxy collection install git+https://github.com/confluentinc/cp-ansible.git

Cloning into '/Users/altfatterz/.ansible/tmp/ansible-local-55213mp67c74w/tmprr8pvmz7/cp-ansiblecpjsc9ix'...
remote: Enumerating objects: 567, done.
remote: Counting objects: 100% (567/567), done.
remote: Compressing objects: 100% (387/387), done.
remote: Total 567 (delta 206), reused 299 (delta 125), pack-reused 0
Receiving objects: 100% (567/567), 255.87 KiB | 9.48 MiB/s, done.
Resolving deltas: 100% (206/206), done.
Your branch is up to date with 'origin/7.2.1-post'.
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'confluent.platform:7.2.1' to '/Users/altfatterz/.ansible/collections/ansible_collections/confluent/platform'
Created collection for confluent.platform:7.2.1 at /Users/altfatterz/.ansible/collections/ansible_collections/confluent/platform
confluent.platform:7.2.1 was installed successfully
```

```bash
$ ansible-playbook -i hosts.yml confluent.platform.all
```

Resources:

1. Confluent Platform on Azure: https://github.com/osodevops/terraform-azure-confluent-platform