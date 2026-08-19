terraform {
  backend "s3" {
    bucket = "remote-backend-s3-bucket-demo-18082026"
    key    = "adephumie/terraform.tfstate"
    region = "ca-central-1"
    encrypt      = true

    use_lockfile = true
  }
}