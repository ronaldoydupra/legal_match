variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "AMI for EC2"
  type        = string
}

resource "aws_instance" "this" {
  instance_type = var.instance_type
  ami           = var.ami
}
