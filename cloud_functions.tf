resource "google_cloudfunctions_function" "operator" {
  name        = "Operator"
  description = "Operator proxy method"
  runtime     = "go113"

  available_memory_mb   = 128
  trigger_http          = true
  entry_point           = "Operator"
  vpc_connector         = google_vpc_access_connector.default.name

  labels = {
    deployment-tool = "cli-gcloud"
  }

  environment_variables = {
    JWT_SIGNING_KEY  = data.google_kms_secret.jwt_signing_key.plaintext
    EMAILS_BACKEND   = "https://mails-k3cimrd2pq-uc.a.run.app"
    EMAILS_QPH       = "5"
    NOTARY_BACKEND   = google_cloud_run_service.notary.status[0].url
    NOTARY_QPH       = "30"
    OPERATOR_BACKEND = google_cloud_run_service.operator.status[0].url
    OPERATOR_QPH     = "5"
    REDIS_HOST       = "${google_redis_instance.ratelimit.host}:${google_redis_instance.ratelimit.port}"
  }
}

resource "google_cloudfunctions_function" "notary" {
  name        = "Notary"
  description = "Notary proxy method"
  runtime     = "go113"

  available_memory_mb   = 128
  trigger_http          = true
  entry_point           = "Notary"
  vpc_connector         = google_vpc_access_connector.default.name

  labels = {
    deployment-tool = "cli-gcloud"
  }

  environment_variables = {
    JWT_SIGNING_KEY  = data.google_kms_secret.jwt_signing_key.plaintext
    EMAILS_BACKEND   = "https://mails-k3cimrd2pq-uc.a.run.app"
    EMAILS_QPH       = "5"
    NOTARY_BACKEND   = google_cloud_run_service.notary.status[0].url
    NOTARY_QPH       = "30"
    OPERATOR_BACKEND = google_cloud_run_service.operator.status[0].url
    OPERATOR_QPH     = "5"
    REDIS_HOST       = "${google_redis_instance.ratelimit.host}:${google_redis_instance.ratelimit.port}"
  }
}

# Note: private service used to collect email addresses on https://covidtrace.com landing page
resource "google_cloudfunctions_function" "emails" {
  name        = "Emails"
  description = "Emails proxy method"
  runtime     = "go113"

  available_memory_mb   = 128
  trigger_http          = true
  entry_point           = "Emails"
  vpc_connector         = google_vpc_access_connector.default.name

  labels = {
    deployment-tool = "cli-gcloud"
  }

  environment_variables = {
    JWT_SIGNING_KEY  = data.google_kms_secret.jwt_signing_key.plaintext
    EMAILS_BACKEND   = "https://mails-k3cimrd2pq-uc.a.run.app"
    EMAILS_QPH       = "5"
    NOTARY_BACKEND   = google_cloud_run_service.notary.status[0].url
    NOTARY_QPH       = "30"
    OPERATOR_BACKEND = google_cloud_run_service.operator.status[0].url
    OPERATOR_QPH     = "5"
    REDIS_HOST       = "${google_redis_instance.ratelimit.host}:${google_redis_instance.ratelimit.port}"
  }
}
