locals {
  operator_sha   = "sha256:eee58557fc9aaf729a83c3f844c8f949b016692d39fb0683eba6285cc279e246"
  notary_sha     = "sha256:575f6f841b7d429c57eae622261d681e7296d68902000ecab91dff39c5e58380"
  aggregator_sha = "sha256:7d80ffd14e08b9e701545742856e89829ac115ead8567a59ea45dda94689a993"
}

resource "google_cloud_run_service" "operator" {
  name                       = "operator"
  location                   = "us-central1"
  autogenerate_revision_name = true

  template {
    spec {
      service_account_name = google_service_account.cloudrun.email
      containers {
        image = "gcr.io/ugtrace/operator@${local.operator_sha}"
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
          value = "ugtrace"
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
        env {
          name  = "SENDGRID_API_KEY"
          value = data.google_kms_secret.sendgrid_api_key.plaintext
        }
        env {
          name  = "SENDGRID_DYNAMIC_TEMPLATE_ID"
          value = "d-54d5684aad8c401ba2626f39eea3fafb"
        }
        env {
          name  = "EMAIL_FROM_ADDRESS"
          value = "operator@ugtrace.com"
        }
        env {
          name  = "EMAIL_FROM_NAME"
          value = "UGTrace Operator"
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
        image = "gcr.io/ugtrace/notary@${local.notary_sha}"
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
        image = "gcr.io/ugtrace/notary@${local.notary_sha}"
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
        image = "gcr.io/ugtrace/aggregator@${local.aggregator_sha}"
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
