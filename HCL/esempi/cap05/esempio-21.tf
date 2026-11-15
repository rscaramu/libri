locals {
  rete = {
    nome      = "lab"
    indirizzo = "10.0.1.0/24"
    dns       = ["10.0.1.2", "10.0.1.3"]
  }
  secondo_dns = local.rete.dns[1]
}
