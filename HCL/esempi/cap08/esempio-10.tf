variable "nome" {
  type    = string
  default = "web"
}

locals {
  avviso = <<EOT
Server: ${var.nome}
Stato: attivo
EOT
}
