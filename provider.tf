provider "google" {
  project = "covidtrace"
  region  = "us-central1"
  version = "3.16.0"
}

terraform {
  backend "gcs" {
    bucket  = "covidtrace-terraform"
  }
}
