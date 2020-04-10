resource "google_cloud_scheduler_job" "aggregate" {
  name             = "aggregator"
  description      = "invoke aggregator aggregate job"
  schedule         = "0 * * * *"
  time_zone        = "America/Los_Angeles"
  attempt_deadline = "1800s"

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_service.aggregator.status[0].url}/aggregate"
    oidc_token {
      service_account_email = google_service_account.cloudscheduler.email
    }
  }
}

resource "google_cloud_scheduler_job" "hinting" {
  name             = "hinting"
  description      = "invoke aggregator hinting job"
  schedule         = "30 * * * *"
  time_zone        = "America/Los_Angeles"
  attempt_deadline = "1800s"

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_service.aggregator.status[0].url}/hinting"
    oidc_token {
      service_account_email = google_service_account.cloudscheduler.email
    }
  }
}
