module "network" {
  source = "./modules/network"
}
module "lb" {
  source = "./modules/lb"

}
module "eks" {
  source      = "./modules/eks"
  # instance_id =  module.lb.instance_id
  subnet_public = module.network.subnet_public
  subnet_private = module.network.subnet_private
  # rds_cluster_identifier = module.database.rds_cluster_identifier
  
}
module "database" {
  source = "./modules/database"
  subnet_public = module.network.subnet_public
  subnet_private = module.network.subnet_private
}
