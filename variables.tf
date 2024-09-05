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
  default     = "ami-0c55b159cbfafe1f0"  # Ubuntu AMI
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "my-unique-s3-bucket"
}


variable "vpc_id" {
  description = "The VPC ID for the ALB"
  type        = string
}

variable "subnets" {
  description = "List of subnets for the ALB"
  type        = list(string)
}
