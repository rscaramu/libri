module "a1" {
  source   = "./modules/aula"
  nome     = "a1"
  cartella = path.module
}

output "scheda_a1" {
  value = module.a1.file
}
