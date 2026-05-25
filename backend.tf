terraform {
  backend "s3" {
    bucket       = "devops100-terraform-state-605893375337"
    key          = "project24/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}