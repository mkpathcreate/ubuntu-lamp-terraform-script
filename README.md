
##-------------------------------------------
##  Terraform: Deploy A LAMP Stack In AWS  ##
##-------------------------------------------

Edit the passwords in the ubuntu-lamp-install.sh in line 54,56  and 97,98 for mariaDB root password and phpmyadmin user mariaadmin password.

'''
sudo debconf-set-selections<<<"mariadb-server mysql-server/root_password password Rotxerd689!"
sudo debconf-set-selections<<<"mariadb-server mysql-server/root_password_again password Rotxerd689!" 
'''

'''
CREATE USER 'mariaadmin'@localhost IDENTIFIED BY 'Pxcyt268!';
GRANT ALL PRIVILEGES ON *.* TO 'mariaadmin'@localhost IDENTIFIED BY 'Pxcyt268!';
'''

## Create a directory and get inside it
mkdir terraform && cd terraform

## Format code
terraform fmt

## Initialize terraform (downloads provider [AWS] packages)
terraform init

## Create resource
terraform apply