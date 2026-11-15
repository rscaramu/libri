terraform {
  backend "s3" {
    bucket       = "scuola-stato"
    key          = "orario/collaudo/terraform.tfstate"
    region       = "eu-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
