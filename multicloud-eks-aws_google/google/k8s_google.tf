module "kubernetes" {
    source = "./modules/kubernetes"
    vpc_name = module.network.vpc_name
    private_subnet = module.network.private_subnet
}
module "network" {
    source = "./modules/networks"
    
}