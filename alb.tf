# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "demo-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  enable_deletion_protection = false

  tags = {
    Name = "demo-app-lb"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.demo-vpc.id

  tags = {
    Name = "alb_sg"
  }
}

# Ingress Rule for ALB (Allow HTTP)
resource "aws_vpc_security_group_ingress_rule" "allow_http_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP traffic"
}

# Ingress Rule for ALB (Allow HTTPS)
resource "aws_vpc_security_group_ingress_rule" "allow_https_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow HTTPS traffic"
}

# Egress Rule for ALB
resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

# Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "demo-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo-vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "demo-app-tg"
  }
}

# Target Group Attachment for EC2-1
resource "aws_lb_target_group_attachment" "app_tg_attachment_1" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.ec2_1.id
  port             = 80
}

# Target Group Attachment for EC2-2
resource "aws_lb_target_group_attachment" "app_tg_attachment_2" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.ec2_2.id
  port             = 80
}

# ALB Listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = {
    Name = "demo-app-listener"
  }
}

# Output the ALB DNS name
output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.app_lb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_lb.app_lb.zone_id
}