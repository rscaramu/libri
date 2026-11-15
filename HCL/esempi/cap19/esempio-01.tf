terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
  }
}

variable "nome" {
  type        = string
  description = "Nome dell'aula."
}

variable "posti" {
  type        = number
  description = "Numero di posti."
  default     = 24
}

variable "cartella" {
  type        = string
  description = "Cartella in cui scrivere la scheda."
}

resource "local_file" "scheda" {
  filename = "${var.cartella}/${var.nome}.txt"
  content  = "Aula ${var.nome}: ${var.posti} posti\n"
}

output "file" {
  description = "Percorso della scheda creata."
  value       = local_file.scheda.filename
}

output "posti" {
  description = "Numero di posti dell'aula."
  value       = var.posti
}
