resource "google_service_account" "cloudrun" {
  account_id   = "cloudrun"
  display_name = "cloudrun"
}

resource "google_service_account_iam_member" "cloudrun_editor" {
  service_account_id = google_service_account.notary.name
  role               = "roles/editor"
  member             = "serviceAccount:${google_service_account.cloudrun.email}"
}

resource "google_service_account" "notary" {
  account_id   = "notary"
  display_name = "notary"
}

resource "google_service_account_iam_member" "notary_token_creator" {
  service_account_id = google_service_account.notary.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.notary.email}"
}

resource "google_service_account_key" "notary" {
  service_account_id = google_service_account.notary.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_service_account" "cloudscheduler" {
  account_id   = "cloudscheduler"
  display_name = "cloudscheduler"
}
