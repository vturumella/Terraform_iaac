provider "kubernetes" {
  region = var.region

}
provider "aws" {
  region     = var.region
  access_key = var.access
  secret_key = var.secret_key
}