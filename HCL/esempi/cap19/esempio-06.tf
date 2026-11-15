module "lab" {
  source   = "./modules/aula"
  for_each = { elettronica = 20, sistemi = 18 }

  nome     = each.key
  posti    = each.value
  cartella = path.module
}

output "totale_posti" {
  value = module.a1.posti + sum(values(module.lab)[*].posti)
}
