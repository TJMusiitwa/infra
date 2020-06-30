provider "google" {
  project = "ugtrace"
  region  = "us-central1"
  version = "3.16.0"
}

terraform {
  backend "gcs" {
    bucket  = "ugtrace-terraform"
  }
}
