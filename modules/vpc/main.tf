# VPC resource
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

# Subnet resource
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"  # Ensure this matches your region
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1b"  # Ensure this matches your region
  map_public_ip_on_launch = true
}

# Outputs
output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnets" {
  value = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}
