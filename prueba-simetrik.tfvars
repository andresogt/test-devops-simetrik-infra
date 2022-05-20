#Network Module

region               = "us-east-1"
vpc_cidr             = "172.33.0.0/16"
private_subnet1_cidr = "172.33.128.0/20"
public_subnet1_cidr  = "172.33.0.0/20"
private_subnet2_cidr = "172.33.144.0/20"
public_subnet2_cidr  = "172.33.16.0/20"
tags                 = "VPC Prueba DevOps"

#ECS Module
container_port             = "8000"
