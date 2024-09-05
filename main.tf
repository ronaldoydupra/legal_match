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
  source = "./modules/alb"
}
