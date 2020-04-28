resource "google_storage_bucket" "archive" {
  name               = "covidtrace-archive"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "archive_cloudrun" {
  bucket = google_storage_bucket.archive.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
}

resource "google_storage_bucket" "symptoms" {
  name               = "covidtrace-symptoms"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "symptoms_notary" {
  bucket = google_storage_bucket.symptoms.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.notary.email}"
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

resource "google_storage_bucket_iam_member" "operator_cloudrun" {
  bucket = google_storage_bucket.operator.name
  role   = "roles/storage.objectAdmin"
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

resource "google_storage_bucket_iam_member" "locations_cloudrun" {
  bucket = google_storage_bucket.locations.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
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

resource "google_storage_bucket_iam_member" "bluetooth_cloudrun" {
  bucket = google_storage_bucket.bluetooth.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
}

resource "google_storage_bucket" "exposure_keys_holding" {
  name               = "covidtrace-exposure-keys-holding"
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

resource "google_storage_bucket_iam_member" "exposure_keys_notary" {
  bucket = google_storage_bucket.exposure_keys_holding.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.notary.email}"
}

resource "google_storage_bucket_iam_member" "exposure_keys_cloudrun" {
  bucket = google_storage_bucket.exposure_keys_holding.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
}

resource "google_storage_bucket" "exposure_keys_published" {
  name               = "covidtrace-exposure-keys-published"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "exposure_keys_publish_cloudrun" {
  bucket = google_storage_bucket.exposure_keys_published.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
}

resource "google_storage_bucket_iam_member" "exposure_keys_publish_allusers" {
  bucket = google_storage_bucket.exposure_keys_published.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket" "publish" {
  name               = "covidtrace-published"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "publish_cloudrun" {
  bucket = google_storage_bucket.publish.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
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

resource "google_storage_bucket" "test_tokens" {
  name               = "covidtrace-test-tokens"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "test_tokens_elevated_notary" {
  bucket = google_storage_bucket.test_tokens.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.elevated_notary.email}"
}

resource "google_storage_bucket" "whitelist" {
  name               = "covidtrace-whitelist"
  location           = "US"
  force_destroy      = true
  bucket_policy_only = false
}

resource "google_storage_bucket_iam_member" "whitelist_cloudrun" {
  bucket = google_storage_bucket.whitelist.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
}
