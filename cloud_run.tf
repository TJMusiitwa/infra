resource "google_cloud_run_service" "operator" {
  name                       = "operator"
  location                   = "us-central1"
  autogenerate_revision_name = true

  template {
    spec {
      service_account_name = google_service_account.cloudrun.email
      containers {
        image = "gcr.io/covidtrace/operator@sha256:8a42d06d7d5887b43204d0a9e22c314183648a0ac4560d21df99424a1632340b"
        env {
          name  = "TWILIO_FROM_NUMBER"
          value = data.google_kms_secret.twilio_from_number.plaintext
        }
        env {
          name  = "TWILIO_ACCOUNT_SID"
          value = data.google_kms_secret.twilio_account_sid.plaintext
        }
        env {
          name  = "TWILIO_AUTH_TOKEN"
          value = data.google_kms_secret.twilio_auth_token.plaintext
        }
        env {
          name  = "CLOUD_STORAGE_BUCKET"
          value = google_storage_bucket.operator.name
        }
        env {
          name  = "CLOUD_STORAGE_WHITELIST_BUCKET"
          value = google_storage_bucket.whitelist.name
        }
        env {
          name  = "HASH_SALT"
          value = data.google_kms_secret.hash_salt.plaintext
        }
        env {
          name  = "JWT_NAMESPACE"
          value = "covidtrace"
        }
        env {
          name  = "JWT_SIGNING_KEY"
          value = data.google_kms_secret.jwt_signing_key.plaintext
        }
        env {
          name  = "JWT_TOKEN_DURATION"
          value = "24h"
        }
        env {
          name  = "JWT_REFRESH_DURATION"
          value = "2016h"
        }
        env {
          name  = "JWT_ELEVATED_TOKEN_DURATION"
          value = "24h"
        }
        env {
          name  = "JWT_ELEVATED_REFRESH_DURATION"
          value = "2016h"
        }
        env {
          name  = "JWT_ELEVATED_ROLE"
          value = "elevated_user"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "notary" {
  name                       = "notary"
  location                   = "us-central1"
  autogenerate_revision_name = true

  template {
    spec {
      service_account_name = google_service_account.cloudrun.email
      containers {
        image = "gcr.io/covidtrace/notary@sha256:c4d74b549bd4d5247aed234346455ac6693252db08c10e585911ca1b928a75c2"
        env {
          name  = "GOOGLE_SERVICE_ACCOUNT"
          value = base64decode(google_service_account_key.notary.private_key)
        }
        env {
          name  = "CLOUD_STORAGE_BUCKETS"
          value = "${google_storage_bucket.locations.name},${google_storage_bucket.symptoms.name},${google_storage_bucket.exposures.name},${google_storage_bucket.bluetooth.name},${google_storage_bucket.exposure_keys_holding.name}"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "elevated_notary" {
  name                       = "elevated-notary"
  location                   = "us-central1"
  autogenerate_revision_name = true

  template {
    spec {
      service_account_name = google_service_account.cloudrun.email
      containers {
        image = "gcr.io/covidtrace/notary@sha256:c4d74b549bd4d5247aed234346455ac6693252db08c10e585911ca1b928a75c2"
        env {
          name  = "GOOGLE_SERVICE_ACCOUNT"
          value = base64decode(google_service_account_key.elevated_notary.private_key)
        }
        env {
          name  = "CLOUD_STORAGE_BUCKETS"
          value = google_storage_bucket.test_tokens.name
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "aggregator" {
  name                       = "aggregator"
  location                   = "us-central1"
  autogenerate_revision_name = true

  template {
    spec {
      service_account_name = google_service_account.cloudrun.email
      containers {
        image = "gcr.io/covidtrace/aggregator@sha256:578b531476956b2b7d8c09a1b381fc6f3825048f6791f5d6d2fbb2367dfceb40"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "aggregator_cloudscheduler" {
  location = google_cloud_run_service.aggregator.location
  project  = google_cloud_run_service.aggregator.project
  service  = google_cloud_run_service.aggregator.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.cloudscheduler.email}"
}
