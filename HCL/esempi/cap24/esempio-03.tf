locals {
  taglie = {
    default    = 1
    collaudo   = 2
    produzione = 4
  }
  cpu = lookup(local.taglie, terraform.workspace, 1)
}

resource "terraform_data" "server" {
  input = "${terraform.workspace}-${local.cpu}cpu"
}

output "ambiente" {
  value = terraform.workspace
}

output "cpu" {
  value = local.cpu
}
