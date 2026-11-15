variable "con_registro" {
  type    = bool
  default = true
}

resource "local_file" "registro" {
  count    = var.con_registro ? 1 : 0
  filename = "${path.module}/registro.txt"
  content  = "Registro attivo\n"
}

output "registro" {
  value = one(local_file.registro[*].filename)
}
