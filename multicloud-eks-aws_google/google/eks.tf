module "instance" {
  source      = "./modules/instance"
  subnet_name = module.network.subnet_name
}
module "network" {
  source       = "./modules/network"
  forward_rule = module.lb.forward_rule
}
module "lb" {
  source               = "./modules/lb"
  ws-instance-template = module.instance.ws-instance-template
}
module "database" {
  source = "./modules/Database"
}