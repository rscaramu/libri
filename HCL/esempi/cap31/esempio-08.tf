variable "aula" {
  type = string
}

source "file" "motd" {
  content = "Lab ${upper(var.scuola)}, aula ${var.aula}\n"
  target  = "uscita/motd-${local.nome}.txt"
}
