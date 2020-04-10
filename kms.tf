resource "google_kms_key_ring" "keyring" {
  name     = "keyring"
  location = "us-central1"
}

resource "google_kms_crypto_key" "key" {
  name     = "key"
  key_ring = google_kms_key_ring.keyring.self_link
}

data "google_kms_secret" "twilio_from_number" {
  crypto_key = google_kms_crypto_key.key.self_link
  ciphertext = "CiQAmXuWVMJqhYYEQSL/2tBS6HArzMWIpIyiHEWvDl4rnAyPkQ0SNQA5K32IFfoPwf72qXRAM/G67stPnTTTrS1x0HqbbV8fRThafktWFThTkvHzUJ+Tcf9T7/HE"
}

data "google_kms_secret" "twilio_account_sid" {
  crypto_key = google_kms_crypto_key.key.self_link
  ciphertext = "CiQAmXuWVMPWEkvkRijOwKrPIhJLOJtyGBDONg69Wpdpd/MNaIQSSwA5K32I8ZKBU6ie0mnQQhbGa0H6ksmwmOA8vubkXBc1YntfD1CyVLwuUftMVQhA7HF9c0ApfGNOBdKX0U8YNi+osyytWJAuCSiDhQ=="
}

data "google_kms_secret" "twilio_auth_token" {
  crypto_key = google_kms_crypto_key.key.self_link
  ciphertext = "CiQAmXuWVBF0gNMzo+pChsTN3aqzxxXufw7y/pvt78f1xg+2facSSQA5K32IpvA9mqL0IMe8HYsDKVkWY3LexO4wlyrmrziwccYI5c2BU3RLDBV9RayybhSANU9FgI2AR5GWoigT/UQ8740WlAEDohA="
}

data "google_kms_secret" "jwt_signing_key" {
  crypto_key = google_kms_crypto_key.key.self_link
  ciphertext = "CiQAmXuWVMdIwzgOFBRDtoTJf1FyEsqqln3Pjuzmnfx6B2XDL94SaQA5K32IRfPkBVICX1f+EzANWhPwQ83n/5k4LSrwmxPuoQ5K1yO+ON65BnNeMLqdVqXXYmudT+jaC1OxZc7rWiT6AGzpYZjIrX7hQwmzQ6bC6cXaCrJCla+VrsvFHI+DMUHnUciM0WdLQQ=="
}

data "google_kms_secret" "hash_salt" {
  crypto_key = google_kms_crypto_key.key.self_link
  ciphertext = "CiQAmXuWVC4bH5P0oz/B43d3H9Ztn2ZuCWyYEgdDVSi5xlWCCQ0SqgEAOSt9iF/p/sIt6KydnJp5Qq+pRu0UqtmyPYFnVwPBzmG8uYFIdrtpdmDCPLp+shW8fbjelqSFhKnYxWwji4epmJpsdjofbb1BlTYisA9wghc7/3czRc+eDCIaeqt6dyvJDw2GywyNODyk/N8I7FRd0XreLLXPkkm1AzgVZmi3AXc8YnKZy8COlb+4ikSWS0dmZdYQ2wryh7Kga8sKvrJP31A/2Tfri/skzw=="
}
