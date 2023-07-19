terraform {
  required_providers {
    google = {
      version = "~> 4.70.0"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = "${file("${var.access}")}"

}
