locals {
  env = [for k, v in var.variabili_ambiente : "${k}=${v}"]
}
