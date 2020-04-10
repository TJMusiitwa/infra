resource "google_storage_bucket_object" "config_file" {
  name          = "config.json"
  bucket        = google_storage_bucket.config.name
  cache_control = "private"

  content = jsonencode({
    "notaryUrl" = google_cloudfunctions_function.notary.https_trigger_url
    "operatorUrl" = google_cloudfunctions_function.operator.https_trigger_url
    "archiveBucket" = google_storage_bucket.archive.name
    "exposureBucket" = google_storage_bucket.exposures.name
    "holdingBucket" = google_storage_bucket.locations.name
    "symptomBucket" = google_storage_bucket.symptoms.name
    "publishedBucket" = google_storage_bucket.publish.name
    "tokenBucket" = google_storage_bucket.bluetooth.name
    "aggS2Index" = 0
    "aggS2Levels" = [8, 10, 12]
    "compareS2Level" = 18
    "reportS2Level" = 22
    "exposureS2Level" = 10
  })
}
