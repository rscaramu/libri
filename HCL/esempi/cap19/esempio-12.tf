module "aula" {
  source   = "./modules/aula"
  for_each = toset(["a1", "a2", "a3"])

  nome     = each.key
  posti    = 28
  cartella = path.module
}

output "schede" {
  value = { for nome, m in module.aula : nome => m.file }
}
