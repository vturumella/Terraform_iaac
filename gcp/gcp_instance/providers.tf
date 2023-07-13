provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
  credentials = file("../root-welder-383716-da9dc216f477.json")
}