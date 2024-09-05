resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
}

output "instance_id" {
  value = aws_instance.example.id
}
