provider "google" {
  region      = var.region
  credentials = file("~/indigo-altar-345111-b111820236b3.json")
  project = var.project
 
}