data "terraform_remote_state" "rete" {
  backend = "s3"

  config = {
    bucket = "scuola-stato-opentofu"
    key    = "rete/produzione/terraform.tfstate"
    region = "eu-south-1"
  }
}

locals {
  rete         = data.terraform_remote_state.rete.outputs
  id_sottorete = local.rete.id_sottorete
}
