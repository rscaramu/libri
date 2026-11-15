resource "random_pet" "codice" {
  for_each = toset(var.aule)
}

resource "local_file" "aula" {
  for_each = toset(var.aule)
  filename = "${path.module}/${each.key}.txt"
  content  = "Codice: ${random_pet.codice[each.key].id}\n"
}
