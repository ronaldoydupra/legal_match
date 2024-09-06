output "alb_dns" {
  value = aws_alb.this.dns_name  # Adjust according to your actual resource
}