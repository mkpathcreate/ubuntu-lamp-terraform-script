#creates VPC, one public subnet, two private subnets, one EC2 instance and one MYSQL RDS instance
#declare variables

#Choose Region
variable "region" {
  default = "us-west-2"
}

####Credentials####
# This picks up saved AWS Credentials in your AWS cli locally, check with command
#$ aws configure list
variable "profile" {
  type    = string
  default = "phporegon"
}

# Entere API ID and Secret Key
variable "access_key" {
  default = "<your_access_key>"
}
variable "secret_key" {
  default = "<your_secret_key>"
}

variable "private_key" {
  default = "7t-php-dev"
}







## Pre-Built Ubuntu LAMP AMI's you can enter here.
variable "images" {
  type = map(string)
  default = {
    "us-east-1"      = "ami-0937dcc711d38ef3f"
    "us-east-2"      = "ami-04328208f4f0cf1fe"
    "us-west-1"      = "ami-0799ad445b5727125"
    "us-west-2"      = "ami-017fecd1353bcc96e"
    "ap-south-1"     = "ami-062df10d14676e201"
    "ap-northeast-2" = "ami-018a9a930060d38aa"
    "ap-southeast-1" = "ami-04677bdaa3c2b6e24"
    "ap-southeast-2" = "ami-0c9d48b5db609ad6e"
    "ap-northeast-1" = "ami-0d7ed3ddb85b521a6"
    "ca-central-1"   = "ami-0de8b8e4bc1f125fe"
    "eu-central-1"   = "ami-0eaec5838478eb0ba"
    "eu-west-1"      = "ami-0fad7378adf284ce0"
    "eu-west-2"      = "ami-0664a710233d7c148"
    "eu-west-3"      = "ami-0854d53ce963f69d8"
    "eu-north-1"     = "ami-6d27a913"
  }
}



variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "subnet_one_cidr" {
  default = "10.0.1.0/24"
}
variable "subnet_two_cidr" {
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}
variable "route_table_cidr" {
  default = "0.0.0.0/0"
}
variable "web_ports" {
  default = ["22", "80", "443", "3306"]
}
variable "db_ports" {
  default = ["22", "3306"]
}


#aws provider
/*
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}
*/




#Pre Requisties 
/*
1.) Create Key Pairs with following names in the new region in EC2 Panel.

  7t-php-dev
	7t-php-dev-app-bastion
	7t-php-dev-db-bastion
	7t-php-qa
	7t-php-sayhey-app-bastion
	Php_eNoah_Dev

2.) Create Target Groups in EC2 Panel

#This picks up the API ID and Secret Key saved in AWS Configure profile from your local AWS CLI    
variable "subdomain-name" {
  type    = string
  default = "dev-cloudformation.thephpagency.com"
}


variable "profile" {
  type    = string
  default = "phporegon"
}
#Region To create the Resources
variable "region" {
  type    = string
  default = "us-west-2"
}
variable "aws_availability_zone_1" {
  type    = string
  default = "us-west-2a"
}
variable "aws_availability_zone_2" {
  type    = string
  default = "us-west-2b"
}
variable "s3service_name" {
  type    = string
  default = "com.amazonaws.us-west-2.s3"
}
variable "prod_db" {
  type    = string
  default = "php-one-world-dev"
}



/*

variable "7t-php-dev-app-bastion_key" {
  type = string  
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBSzF22AFej9oUNyBt/m6jB2QyC5KSpOpj9ceX9Eca/eXAM7RVaN3hsNLUwUoW+rUrISOz7qOiDBVixEMhJvV59fKnJnwzpjrm11VJUZTf6pYDchfXGWrVkfZLdHWG8lwpa2daeIcZzOBedcFOMYZGVxqrBXr9Cu3Btmy6nxV2q2JS1998114Gl04eE+ZPdyuXwsbJeqi+2kFpOZfncsd8y1nrHiH6eqr9D+UWp4ZvmhCPUknarpTG5nE+HfvaDtRNeH6noB9kAuI7EsqhBmT7RuZdADGpsZRl+6Ne+CUEvgOfIvGTYTNoDnCXzVYQCxLZ9x4gQwvbuQWtKzuKgT+P"
}

variable "7t-php-dev-db-bastion_key" {
  type = string  
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7FfwAy0p9PZGrs0jsct6ZvIPK8PQP88wIfBnZua4i/Ht0fUjK+Bvz0qEP8dySPdaq1y+elASJi9+RPUk+9TXLvjkhvIOtrDfY67LO74YKi3kANMK7hayilM/dbGxImJEasTyPEr/LgJ2v7S2JORa/SBeFdrncOT4pVZwu4sO2AFyLlb+mSsMxsWyonwJx9pT1flIDuy1ic50+35nEMS2435T7SowpJ/I7ur3kLIgE9l7srIQLQ+Hx6GdUHDxyX4ewULY+J5ARmBciJRVpK0oH+rU/3jlDfVDcKtaF2anDUMfitmTNvp7jNacRiiZxntB6QlnusHGTeQ0ZzqviWHDh"
}

variable "eNoah_Php_Stage_Feed_key" {
  type = string  
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

variable "php-dev-qa-stage-solr-backup_key" {
  type = string  
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

variable "7t-phpqa-v1_key" {
  type = string  
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
*/