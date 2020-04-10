resource "google_redis_instance" "ratelimit" {
  name           = "ratelimit"
  display_name   = "ratelimit"
  memory_size_gb = 1
}

resource "google_vpc_access_connector" "default" {
  name           = "default"
  region         = "us-central1"
  ip_cidr_range  = "10.8.0.0/28"
  network        = "default"
  max_throughput = 300
  min_throughput = 200
}
