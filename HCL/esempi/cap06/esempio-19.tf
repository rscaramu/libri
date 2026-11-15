variable "progetto" {
  type    = string
  default = "registro"
}

variable "ambiente" {
  type    = string
  default = "collaudo"
}

locals {
  prefisso   = "${var.progetto}-${var.ambiente}"
  nome_rete  = "${local.prefisso}-rete"
  nome_disco = "${local.prefisso}-disco"
}
