variable "opzioni" {
  type    = map(number)
  default = { ram = 8 }
}

locals {
  predefinite = { cpu = 2, ram = 4, disco = 20 }
  effettive   = merge(local.predefinite, var.opzioni)
}
