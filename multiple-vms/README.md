```bash
$ terraform fmt
$ terraform validate
$ terraform plan
$ terraform apply
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
$ ssh -i key.pem ubuntu@<public_ip_address>
```

```bash
$ ssh -i key.pem ubuntu@kafka0.westeurope.cloudapp.azure.com
```

```bash
$ terraform show
$ terraform state list
```

