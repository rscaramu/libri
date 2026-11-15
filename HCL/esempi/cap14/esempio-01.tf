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

resource "random_pet" "server" {
  length    = 2
  separator = "-"
}

resource "local_file" "scheda" {
  filename        = "${path.module}/scheda.txt"
  content         = "Server: ${random_pet.server.id}\n"
  file_permission = "0644"
}

output "nome" {
  value = random_pet.server.id
}
