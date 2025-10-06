output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
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