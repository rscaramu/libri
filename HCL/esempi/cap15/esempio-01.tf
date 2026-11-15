terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "local_file" "server" {
  filename = "${path.module}/server.txt"
  content  = "in rete ${local_file.rete.content}"
}

resource "local_file" "rete" {
  filename = "${path.module}/rete.txt"
  content  = random_pet.rete.id
}

resource "random_pet" "rete" {}
