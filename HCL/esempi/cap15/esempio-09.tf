locals {
  nome_a = "a.txt"
  nome_b = "b.txt"
}

resource "local_file" "a" {
  filename = local.nome_a
  content  = local.nome_b
}

resource "local_file" "b" {
  filename = local.nome_b
  content  = local.nome_a
}
