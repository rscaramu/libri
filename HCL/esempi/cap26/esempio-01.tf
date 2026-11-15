terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "nome" {
  type = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9]*$", var.nome))
    error_message = "Nome non valido."
  }
}

variable "posti" {
  type    = number
  default = 24
}

locals {
  etichetta = "aula-${var.nome}"
}

resource "local_file" "scheda" {
  filename = "${path.module}/${local.etichetta}.txt"
  content  = "Aula ${var.nome}: ${var.posti} posti\n"
}

output "etichetta" {
  value = local.etichetta
}

output "file" {
  value = local_file.scheda.filename
}
