# terraform-lamp-script
This script can be referenced within terraform script to install LAMP stack after creating a Ubuntu Server. This only supports Ubuntu as of now.

##-------------------------------------------
##  Terraform: Deploy A LAMP Stack In AWS  ##
##-------------------------------------------
## Create a directory and get inside it
mkdir terraform && cd terraform

## Format code
terraform fmt

## Initialize terraform (downloads provider [AWS] packages)
terraform init

## Create resource
terraform apply