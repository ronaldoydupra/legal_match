variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-2"
  endpoint = "https://s3.us-west-2.amazonaws.com"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "AMI for EC2"
  default     = "ami-01811d4912b4ccb26"  # Ubuntu Server 22.04 LTS (64-bit Arm) ami-01811d4912b4ccb26 - t2.micro
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "lm-test-2025-s3-bucket"
}

 variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}
