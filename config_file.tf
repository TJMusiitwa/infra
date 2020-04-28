resource "google_storage_bucket_object" "config_file" {
  name          = "config.json"
  bucket        = google_storage_bucket.config.name
  cache_control = "private"

  content = jsonencode({
    "aggS2Index"                  = 0
    "aggS2Levels"                 = [8, 10, 12]
    "archiveBucket"               = google_storage_bucket.archive.name
    "compareS2Level"              = 18
    "elevatedNotaryUrl"           = google_cloudfunctions_function.notary.https_trigger_url
    "exposureBucket"              = google_storage_bucket.exposures.name
    "exposureS2Level"             = 10
    "holdingBucket"               = google_storage_bucket.locations.name
    "notaryUrl"                   = google_cloudfunctions_function.notary.https_trigger_url
    "operatorUrl"                 = google_cloudfunctions_function.operator.https_trigger_url
    "publishedBucket"             = google_storage_bucket.publish.name
    "reportS2Level"               = 22
    "symptomBucket"               = google_storage_bucket.symptoms.name
    "timeResolution"              = 15
    "tokenBucket"                 = google_storage_bucket.bluetooth.name
    "exposureKeysHoldingBucket"   = google_storage_bucket.exposure_keys_holding.name
    "exposureKeysPublishedBucket" = google_storage_bucket.exposure_keys_published.name
  })
}
