output "instance_id" {
  value = aws_instance.this.id
}


output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}


output "alb_dns" {
  value = module.alb.alb_dns
}
