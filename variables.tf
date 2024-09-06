variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ami" {
  description = "AMI for EC2"
  default     = "ami-0f0a689dea27d9dc8"  # Ubuntu Server 22.04 LTS (64-bit Arm)
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "lgm-2024-s3-bucket"
}
