resource "google_service_account" "gcptest" {
  account_id   = "gcptest"
  display_name = "My Service Account"
}

data "google_service_account" "gcptest" {
  account_id = google_service_account.gcptest.id
}

resource "google_service_account_key" "gcptest" {
  service_account_id = google_service_account.gcptest.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket" "gcp_buckete" {
  name          = "auto-expiring-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 13
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
