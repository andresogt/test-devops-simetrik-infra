output "dns_alb" {
  description = "DNS name Load Balancer"
  value       = aws_lb.alb-django.dns_name
}