output "instance_id" {
  value = module.ec2_instance.instance_id
}


output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

 

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}
