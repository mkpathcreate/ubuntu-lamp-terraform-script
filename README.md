# terraform-lamp-script
This script can be referenced within terraform script to install LAMP stack after creating a Ubuntu Server. This only supports Ubuntu as of now.


In terraform script, add the following.

Source:
curl -sL https://gist.github.com/ImaginativeShohag/45aeb30b3e43dcf95bf73cb2a4e77046/raw | sudo bash -

```
provisioner "remote-exec" { 
    inline = [
    "sudo /tmp/"
    "curl -sL https://raw.githubusercontent.com/mkpathcreate/terraform-lamp-script/main/ubuntu-lamp-install.sh | sudo bash -"
    ]
  }
```
