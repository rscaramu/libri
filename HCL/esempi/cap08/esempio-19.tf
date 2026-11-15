variable "progetto" {
  type    = string
  default = "registro"
}

variable "ambiente" {
  type    = string
  default = "prod"
}

variable "indice" {
  type    = number
  default = 3
}

locals {
  numero = format("%02d", var.indice)
  nome   = "${var.progetto}-${var.ambiente}-${local.numero}"
}
