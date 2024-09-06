variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "AMI for EC2"
  default     = "ami-070f589e4b4a3fece"  # Ubuntu Server 22.04 LTS (64-bit Arm)
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "my-unique-s3-bucket"
}
