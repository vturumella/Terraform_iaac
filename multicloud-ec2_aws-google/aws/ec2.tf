module "vpc" {
  source = "./modules/vpc"

}
module "microservices" {
  source = "./modules/microservices"
}
module "lb" {
  source = "./modules/lb"
  vpc_id = module.vpc.vpc_id
}
module "database" {
  source = "./modules/database"
}