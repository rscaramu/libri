terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "benvenuto" {
  filename = "${path.module}/benvenuto.txt"
  content  = "Primo file creato con HCL.\n"
}
