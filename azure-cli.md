1. Login Azure cli

```sh
az login
```

2. Check Azure subscription

```sh
az account subscription list
```

### Create an Ubuntu Server 20.04 (or 22.04, or 24.04) based virtual machine using the B1s size or similar

1. Create Azure Resource Group

```sh
az group create --name homework-m1-rg --location northeurope
```

2. Check details about just created resource group

```sh
az group show --name homework-m1-rg
```

3. Create virtual machine

```sh
az vm create \
--resource-group homework-m1-rg \
--name homework-m1-vm \
--image Canonical:ubuntu-24_04-lts:server:latest \
--size Standard_B1s \
--public-ip-sku Standard \
--admin-username azure-admin \
--generate-ssh-keys \
--location northeurope
```

### Add a second hard disk with 20 GB in size, format it with a file system (i.e. EXT4) and mount it

1. Attach a new disk to the VM

```sh
az vm disk attach \
   -g homework-m1-rg \
   --vm-name homework-m1-vm \
   --name data-disk \
   --new \
   --size-gb 20
```

2. Execute custom script to format and mount the disk.

- `nofail 0 2` - recommended for Azure data disks

```sh
az vm extension set \
  --resource-group homework-m1-rg \
  --vm-name homework-m1-vm \
  --publisher Microsoft.Azure.Extensions \
  --name format-and-mount \
  --settings '{
  "commandToExecute": "parted /dev/sdc --script mklabel gpt mkpart primary ext4 0% 100% && mkfs.ext4 /dev/sdc1 && mkdir -p /mnt/data && sudo mount /dev/sdc1 /mnt/data && echo \\"/dev/sdc1 /mnt/data ext4 defaults,nofail 0 2\\" | tee -a /etc/fstab"
}'
```

### Install Apache web server (the package is named apache2) and make sure it is started and set to start automatically on boot

1. Install Apache and ensure start on boot

```sh
az vm extension set \
  --resource-group homework-m1-rg \
  --vm-name homework-m1-vm \
  --publisher Microsoft.Azure.Extensions \
  --name install-apache2 \
  --settings '{
  "commandToExecute": "apt-get update && sudo apt-get install apache2 -y && systemctl enable --now apache2"
}'
```

### Adjust the configuration of Apache (the default virtual host configuration is at /etc/apache2/sites-available/000-default.conf) to make it listen on port 8080 instead of port 80

```sh
az vm extension set \
  --resource-group homework-m1-rg \
  --vm-name homework-m1-vm \
  --publisher Microsoft.Azure.Extensions \
  --name change-port-and-restart \
  --settings '{
  "commandToExecute": "sed -i \"s/<VirtualHost \*:80>/<VirtualHost \*:8080>/\" /etc/apache2/sites-available/000-default.conf && systemctl restart apache2"
}'
```

2. Open port 80 for web traffic

```sh
az vm open-port --port 8080 --resource-group homework-m1-rg --name homework-m1-vm
```

### Create a simple index.html page that displays `Hello Azure`

```sh
az vm extension set \
  --resource-group homework-m1-rg \
  --vm-name homework-m1-vm \
  --publisher Microsoft.Azure.Extensions \
  --name change-port-and-restart \
  --settings '{
  "commandToExecute": "commandToExecute": "echo \"<h1>Hello Azure</h1><p>running on $(hostname)</p><p>$(date)</p>\" | tee /var/www/html/index.html && systemctl restart apache2"
}'
```
