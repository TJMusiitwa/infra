resource "google_storage_bucket" "archive" {
  name               = "covidtrace-archive"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket" "symptoms" {
  name               = "covidtrace-symptoms"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket" "operator" {
  name               = "covidtrace-operator"
  location           = "US-CENTRAL1"
  force_destroy      = true
  bucket_policy_only = false

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 1
    }
  }
}

resource "google_storage_bucket_iam_member" "operator_notary" {
  bucket = google_storage_bucket.operator.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
}

resource "google_storage_bucket" "exposures" {
  name               = "covidtrace-exposures"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "exposures_notary" {
  bucket = google_storage_bucket.exposures.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.notary.email}"
}

resource "google_storage_bucket" "locations" {
  name               = "covidtrace-holding"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 1
    }
  }
}

resource "google_storage_bucket_iam_member" "locations_notary" {
  bucket = google_storage_bucket.locations.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.notary.email}"
}

resource "google_storage_bucket" "bluetooth" {
  name               = "covidtrace-tokens"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 1
    }
  }
}

resource "google_storage_bucket_iam_member" "bluetooth_notary" {
  bucket = google_storage_bucket.bluetooth.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.notary.email}"
}

resource "google_storage_bucket" "publish" {
  name               = "covidtrace-published"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "publish_allusers" {
  bucket = google_storage_bucket.publish.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket" "config" {
  name               = "covidtrace-config"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "config_allusers" {
  bucket = google_storage_bucket.config.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
