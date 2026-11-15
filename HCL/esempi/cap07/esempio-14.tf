locals {
  cpu_per_taglia = {
    piccola = 1
    media   = 2
    grande  = 4
  }
  cpu = lookup(local.cpu_per_taglia, var.taglia, 8)
}
