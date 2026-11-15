terraform {
  backend "s3" {
    key          = "registro/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
