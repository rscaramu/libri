resource "local_file" "aula" {
  for_each = toset(var.aule)
  filename = "${path.module}/${each.key}.txt"
  content  = "Aula ${each.key}\n"
}
