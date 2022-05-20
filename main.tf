module "network" {
    source = "./src/modules/network"
    
    vpc_cidr             = var.vpc_cidr
    private_subnet1_cidr = var.private_subnet1_cidr
    public_subnet1_cidr  = var.public_subnet1_cidr
    private_subnet2_cidr = var.private_subnet2_cidr
    public_subnet2_cidr  = var.public_subnet2_cidr
    tags                 = var.tags
}


module "ecs" {
    source = "./src/modules/ecs"
    
    vpc_id               = module.network.vpc_id
    private_subnet1_id   = module.network.private_subnet1_id
    private_subnet2_id   = module.network.private_subnet2_id
    public_subnet1_id   = module.network.public_subnet1_id
    public_subnet2_id   = module.network.public_subnet2_id
    container_port       = var.container_port
    
}