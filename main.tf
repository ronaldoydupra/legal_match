provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

terraform {

  backend "local" {
    path = "/var/jenkins_home/terraform_state/terraform.tfstate"
  }
}


module "ec2_instance" {
  source         = "./modules/ec2"
  instance_type  = var.instance_type
  ami            = var.ami
}

module "s3_bucket" {
  source         = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
}

module "vpc" {
  source = "./modules/vpc"
}


module "alb" {
  source  = "./modules/alb"
  vpc_id  = module.vpc.vpc_id     # Use the output of the VPC module for vpc_id
  subnets = module.vpc.subnets    # Use the output of the VPC module for subnets
}


