variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "AMI for EC2"
  default     = "ami-0c55b159cbfafe1f0"  # Ubuntu AMI
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "my-unique-s3-bucket"
}
