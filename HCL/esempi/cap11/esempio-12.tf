variable "etichette" {
  type = map(string)
  default = {
    ambiente = "collaudo"
    classe   = "5A"
  }
}

locals {
  etichette_base = {
    progetto = "registro"
    gestito  = "opentofu"
    ambiente = "sviluppo"
  }
  etichette = merge(local.etichette_base, var.etichette)
}
