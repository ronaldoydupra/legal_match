resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  subnets            = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}"]
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}
