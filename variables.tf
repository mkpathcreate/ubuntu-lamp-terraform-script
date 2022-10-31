#creates VPC, one public subnet, two private subnets, one EC2 instance and one MYSQL RDS instance
#declare variables

#Choose Region
variable "region" {
  default = "us-west-2"
}

####Credentials####
# This picks up saved AWS Credentials in your AWS cli locally, check with command
#$ aws configure list, check documentation in this link
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
variable "profile" {
  type    = string
  default = "phporegon"
}

# Entere API ID and Secret Key, this NOT recommended method though, since it exposes
# access key and sceret key in the code.
variable "access_key" {
  default = "<your_access_key>"
}
variable "secret_key" {
  default = "<your_secret_key>"
}

variable "private_key" {
  default = "7t-php-dev"
}
##This will add the tags to all resources created
#for identification.
variable "project_name" {
  default = "Terraform from Izumo"
}
# Enviroment, Dev or Prod
variable "project_environment" {
  default = "dev"
}






## Pre-Built Ubuntu LAMP AMI's you can enter here. The below is taken from
# https://cloud-images.ubuntu.com/locator/ec2/ and latest releases.
variable "images" {
  type = map(string)
  default = {
    /*
    "us-east-1"      = "ami-08c40ec9ead489470"
    "us-east-2"      = "ami-097a2df4ac947655f"
    "us-west-1"      = "ami-02ea247e531eb3ce6"
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
    */
af-south-1= "ami-049f3776a271bc3b7"
ap-east-1= "ami-0b05a304ab4fa3be8"
ap-northeast-1= "ami-075b4e4fa32027c1e"
ap-northeast-2= "ami-06192e39cbbb7a8dc"
ap-northeast-3= "ami-0e881f8ae26f2d134"
ap-south-1= "ami-0014a66cfcc80ac59"
ap-southeast-1= "ami-0720a5ea8181d7788"
ap-southeast-2= "ami-0e2539ff51477b0e9"
ap-southeast-3= "ami-02d51c7efeae16ebe"
ca-central-1= "ami-0bd660bf0bc3f1ae1"
eu-central-1= "ami-09309b588b3d482e8"
eu-north-1= "ami-0b7e06f5b396bf4cc"
eu-south-1= "ami-065518095cabb71aa"
eu-west-1= "ami-0539dc4a10640398c"
eu-west-2= "ami-04b57051a8c8f7c8d"
eu-west-3= "ami-0cdb2b59f7bab04a2"
me-central-1= "ami-099e4dcb953792c10"
me-south-1= "ami-0afaec593e1598c33"
sa-east-1= "ami-032219713a8731e2a"
us-east-1= "ami-0fc2ee4e15eaf3d80"
us-east-2= "ami-0cdfb79f8947c76aa"
us-west-1= "ami-04a16a5d780a10e8f"
us-west-2= "ami-0838be7ba2ee17e46"

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