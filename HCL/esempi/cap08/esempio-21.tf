variable "backup" {
  type    = bool
  default = false
}

locals {
  a = "backup: %{if var.backup}attivo%{else}disattivo%{endif}"
  b = "backup: ${var.backup ? "attivo" : "disattivo"}"
}
