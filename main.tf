terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform/state.tfstate"
    region         = "ap-southeast-1"
  }
}

provider "aws" {
  region = var.aws_region
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
