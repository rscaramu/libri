module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "scuola"
  cidr = "10.0.0.0/16"
}
