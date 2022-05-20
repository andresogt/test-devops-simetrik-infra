output "vpc_id" {
  description = "Id de la VPN Simetrik"
  value       = aws_vpc.vpc_prueba_simetrik.id 
}

output "private_subnet1_id" {
  description = "Id of public subnet 1"
  value       = aws_subnet.private_subnet1.id
}

output "private_subnet2_id" {
  description = "Id of public subnet 2"
  value       = aws_subnet.private_subnet2.id
}

output "public_subnet1_id" {
  description = "Id of public subnet 1"
  value       = aws_subnet.public_subnet1.id
}

output "public_subnet2_id" {
  description = "Id of public subnet 2"
  value       = aws_subnet.public_subnet2.id
}