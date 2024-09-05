variable "vpc_id" {
  description = "The VPC ID for the ALB"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

