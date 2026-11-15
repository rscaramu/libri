locals {
  prefisso = "scuola"
  nome     = "${local.prefisso}-server"
}

output "nome_completo" {
  value = local.nome
}
