provider "aws" {
  region = var.aws_region
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

module "alb" {
  source  = "./modules/alb"
  vpc_id  = var.vpc_id
  subnets = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]  # Example Subnet IDs
}
