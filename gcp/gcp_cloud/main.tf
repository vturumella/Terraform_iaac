provider "google" {
  project     = var.project
  region      = var.region
  credentials = var.access
}
module "database" {
  source      = "./modules/database"
  count       = var.no_of_db_instances
  /* db_user     = var.db_user
  db_password = var.db_password */
}
module "instance_template" {
  source             = "./modules/instance_template"
  vpc-name           = module.vpc.xcloud-vpc
  subnetwork = var.subnet-name
  project            = var.project
  region             = var.region
  image              = var.image
  name               = var.name
  enable_autoscaling = var.enable_autoscaling
 }
module "lb" {
  count                = var.enable_autoscaling?1:0
  source               = "./modules/lb"
  name                 = var.name
  instance_template= var.instance_template
  zones                = var.zones
  project              = var.project
  webserver_count      = var.webserver_count
  region               = var.region
}
module "microservice" {
  source = "./modules/microservice"
  /* appserver_count = var.appserver_count */
  zones = var.zones
  image = var.image
  instance_type = var.instance_type
  vpc-name           = var.vpc-name
  subnet-name = var.subnet-name
   
}
module "vpc" {
  source = "./modules/vpc"
  region = var.region
}

