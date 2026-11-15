module "rete" {
  source = "./modules/rete"
  nome   = "laboratori"
  cidr   = "10.20.0.0/16"
}

module "server" {
  source       = "./modules/server"
  nome         = "registro"
  id_sottorete = module.rete.id_sottoreti["sistemi"]
}

module "dns" {
  source    = "./modules/dns"
  nome      = "registro"
  indirizzo = module.server.indirizzo_ip
}
