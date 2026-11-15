terraform {
  backend "s3" {
    key          = "orario/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
