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

resource "random_integer" "n" {
  min = 1
  max = 30
}

resource "local_file" "estratto" {
  filename = "${path.module}/estratto.txt"
  content  = "Interrogato: ${random_integer.n.result}\n"
}
