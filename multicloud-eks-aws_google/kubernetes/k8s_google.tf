module "kubernetes" {
    source = "./modules/kubernetes"
    vpc_name = module.network.vpc_name
    my_subnet = module.network.my_subnet
}
module "network" {
    source = "./modules/networks"
    
}