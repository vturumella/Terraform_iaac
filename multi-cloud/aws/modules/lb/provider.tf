terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}
provider "aws" {
  region     = var.region
  access_key = var.access
  secret_key = var.secret_key

}