module "database" {
    source = "./modules/database"
    
    
}

module "instance" {
  source           = "./modules/instance"
  project          = var.project
  region           = var.region
  vpc-name         = module.vpc.vpc-name
  subnet-self_link = module.vpc.subnet-self_link
}
module "vpc" {
  source  = "./modules/vpc"
  project = var.project
  region  = var.region
}
module "microservices" {
  source           = "./modules/microservices"
  project          = var.project
  region           = var.region
  vpc-name         = module.vpc.vpc-name
  subnet-self_link = module.vpc.subnet-self_link
}
module "lb" {
  source           = "./modules/lb"
  project          = var.project
  region           = var.region
  ws-inst_tmplt = module.instance.ws-inst_tmplt
  subnet-self_link = module.vpc.subnet-self_link
}
