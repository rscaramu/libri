terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "laboratori" {
  type = map(object({
    posti   = number
    docente = string
  }))
  default = {
    elettronica = { posti = 24, docente = "Rossi" }
    sistemi     = { posti = 20, docente = "Bianchi" }
  }
}

resource "local_file" "scheda" {
  for_each = var.laboratori
  filename = "${path.module}/${each.key}.txt"
  content  = <<-EOT
    Laboratorio: ${each.key}
    Posti: ${each.value.posti}
    Docente: ${each.value.docente}
  EOT
}
