
##  Terraform: Deploy A LAMP Stack In AWS  ##

**This script will deploy a Ubuntu (22.xx) and install**
*
- Apache2
 - MariaDB
 - PHP
 - phpmyadmin
*


Make the following changes in script to make it work for you.

**Edit variables.tf**

Choose Region
```
variable "region" {
  default = "us-west-2"
}
```

This picks up saved AWS Credentials in your AWS cli locally, check with command **aws configure list**, check documentation in this link
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
```
variable "profile" {
  type    = string
  default = "phporegon123"
}
```

The aws key that needs to be used for AWS Instance creation. This should be pre-exist in the region, so create it and update the name here.
```
variable "private_key" {
  default = "AWS-dev-key"
}
```

This will add the tags to all resources created for identification.
```
variable "project_name" {
  default = "Terraform from Izumo"
}
```

Enviroment, Dev or Prod
```
variable "project_environment" {
  default = "dev"
}
```

**Edit ubuntu-lamp-install.sh**

Edit the passwords in the ubuntu-lamp-install.sh in line 54,56 for mariaDB root password

```
sudo debconf-set-selections<<<"mariadb-server mysql-server/root_password password Rotxerd689!"
sudo debconf-set-selections<<<"mariadb-server mysql-server/root_password_again password Rotxerd689!" 
```
and 97,98 for phpmyadmin user mariaadmin password.
```
CREATE USER 'mariaadmin'@localhost IDENTIFIED BY 'Pxcyt268!';
GRANT ALL PRIVILEGES ON *.* TO 'mariaadmin'@localhost IDENTIFIED BY 'Pxcyt268!';
```


## Format code
terraform fmt

## Initialize terraform (downloads provider [AWS] packages)
terraform init

## Create resource
terraform apply
