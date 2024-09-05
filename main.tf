provider "aws" {
  region = var.aws_region
}

module "ec2_instance" {
  source = "./modules/ec2"
  instance_type = var.instance_type
  ami           = var.ami
}

module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.s3_bucket_name
}

module "alb" {
  source = "./modules/alb"
}
