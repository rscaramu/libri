module "archivio" {
  source = "./modules/archivio"
  nome   = "documenti"
}

module "applicazione" {
  source           = "./modules/applicazione"
  nome             = "portale"
  nome_contenitore = module.archivio.nome_contenitore
}
