terraform {
  backend "s3" {
    bucket       = "scuola-stato-opentofu"
    key          = "registro/produzione/terraform.tfstate"
    region       = "eu-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
