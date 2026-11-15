module "rete" {
  source = "../../modules/rete"
  nome   = "produzione"
  cidr   = "10.20.0.0/16"
}

module "server" {
  source       = "../../modules/server"
  nome         = "registro"
  cpu          = 4
  repliche     = 3
  id_sottorete = module.rete.id_sottoreti["servizi"]
}
