output "ec2_instance_id" {
  value = module.ec2_instance.instance_id
}

output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "alb_dns" {
  value = module.alb.alb_dns
}
