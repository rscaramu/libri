variable "utenti" {
  type = map(list(string))
  default = {
    anna  = ["docenti", "admin"]
    bruno = ["docenti"]
    carla = ["ata", "admin"]
  }
}

locals {
  tutti_i_gruppi = values(var.utenti)
  gruppi_piatti  = flatten(local.tutti_i_gruppi)
  gruppi         = sort(distinct(local.gruppi_piatti))
}
