provider "aws" {
  region = "eu-south-1"
}

provider "aws" {
  alias  = "irlanda"
  region = "eu-west-1"
}

resource "aws_s3_bucket" "principale" {
  bucket = "scuola-dati"
}

resource "aws_s3_bucket" "copia" {
  provider = aws.irlanda
  bucket   = "scuola-dati-copia"
}
