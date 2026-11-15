variable "rete" {
  type    = string
  default = "10.20.0.0/16"
}

variable "laboratori" {
  type    = list(string)
  default = ["elettronica", "sistemi", "tpsee"]
}

locals {
  sottoreti = {
    for i, nome in var.laboratori :
    nome => cidrsubnet(var.rete, 8, i)
  }
}
