variable "ambienti" {
  type    = list(string)
  default = ["dev", "prod"]
}

variable "servizi" {
  type    = list(string)
  default = ["web", "db"]
}

locals {
  annidata = [
    for a in var.ambienti : [
      for s in var.servizi : "${a}-${s}"
    ]
  ]
  piatta = flatten(local.annidata)
}
