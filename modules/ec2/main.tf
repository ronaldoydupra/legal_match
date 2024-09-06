variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "AMI for EC2"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs for the EC2 instance"
  type        = list(string)
}

resource "aws_instance" "this" {
  instance_type          = var.instance_type
  ami                   = var.ami
  subnet_id             = var.subnet_id             # Ensure this is specified
  vpc_security_group_ids = var.vpc_security_group_ids # Ensure security groups are specified
}
