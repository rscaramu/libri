provider "aws" {
  region = "eu-south-1"
}

provider "aws" {
  alias  = "irlanda"
  region = "eu-west-1"
}

module "archivio_irlanda" {
  source = "./modules/archivio"
  nome   = "copia"

  providers = {
    aws = aws.irlanda
  }
}
