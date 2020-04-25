locals {
  environment_variables = {
    ELEVATED_NOTARY_BACKEND   = google_cloud_run_service.elevated_notary.status[0].url
    ELEVATED_NOTARY_QPH       = "30"
    EMAILS_BACKEND            = "https://mails-k3cimrd2pq-uc.a.run.app"
    EMAILS_QPH                = "5"
    JWT_SIGNING_KEY           = data.google_kms_secret.jwt_signing_key.plaintext
    NOTARY_BACKEND            = google_cloud_run_service.notary.status[0].url
    NOTARY_QPH                = "30"
    OPERATOR_BACKEND          = google_cloud_run_service.operator.status[0].url
    OPERATOR_QPH              = "5"
    REDIS_HOST                = "${google_redis_instance.ratelimit.host}:${google_redis_instance.ratelimit.port}"
  }

  labels = {
    deployment-tool = "cli-gcloud"
  }
}

resource "google_cloudfunctions_function" "operator" {
  name                  = "Operator"
  description           = "Operator proxy method"
  runtime               = "go113"
  available_memory_mb   = 128
  trigger_http          = true
  entry_point           = "Operator"
  vpc_connector         = google_vpc_access_connector.default.name
  environment_variables = local.environment_variables
  labels                = local.labels
}

resource "google_cloudfunctions_function_iam_member" "operator_invoker" {
  project        = google_cloudfunctions_function.operator.project
  region         = google_cloudfunctions_function.operator.region
  cloud_function = google_cloudfunctions_function.operator.name
  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function" "notary" {
  name                  = "Notary"
  description           = "Notary proxy method"
  runtime               = "go113"
  available_memory_mb   = 128
  trigger_http          = true
  entry_point           = "Notary"
  vpc_connector         = google_vpc_access_connector.default.name
  environment_variables = local.environment_variables
  labels                = local.labels
}

resource "google_cloudfunctions_function_iam_member" "notary_invoker" {
  project        = google_cloudfunctions_function.notary.project
  region         = google_cloudfunctions_function.notary.region
  cloud_function = google_cloudfunctions_function.notary.name
  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function" "elevated_notary" {
  name                  = "ElevatedNotary"
  description           = "ElevatedNotary proxy method"
  runtime               = "go113"
  available_memory_mb   = 128
  trigger_http          = true
  entry_point           = "ElevatedNotary"
  vpc_connector         = google_vpc_access_connector.default.name
  environment_variables = local.environment_variables
  labels                = local.labels
}

resource "google_cloudfunctions_function_iam_member" "elevated_notary_invoker" {
  project        = google_cloudfunctions_function.elevated_notary.project
  region         = google_cloudfunctions_function.elevated_notary.region
  cloud_function = google_cloudfunctions_function.elevated_notary.name
  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

# Note: private service used to collect email addresses on https://covidtrace.com landing page
resource "google_cloudfunctions_function" "emails" {
  name                  = "Emails"
  description           = "Emails proxy method"
  runtime               = "go113"
  available_memory_mb   = 128
  trigger_http          = true
  entry_point           = "Emails"
  vpc_connector         = google_vpc_access_connector.default.name
  environment_variables = local.environment_variables
  labels                = local.labels
}

resource "google_cloudfunctions_function_iam_member" "emails_invoker" {
  project        = google_cloudfunctions_function.emails.project
  region         = google_cloudfunctions_function.emails.region
  cloud_function = google_cloudfunctions_function.emails.name
  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
