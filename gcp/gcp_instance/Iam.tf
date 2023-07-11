resource "google_service_account" "gcptest" {
  account_id   = "gcptest"
  display_name = "My Service Account"
}



data "google_service_account" "gcptest" {
  account_id = google_service_account.gcptest.id
}

output "gcp_service-account" {
  value = google_service_account.gcptest
  
}
