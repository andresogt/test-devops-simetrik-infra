output "vpc_id" {
  value = module.network.vpc_id
}

output "DNS_de_alb" {
  description = "DNS name Load Balancer"
  value       = module.ecs.dns_alb
}