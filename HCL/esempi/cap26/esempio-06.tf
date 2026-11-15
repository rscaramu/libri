run "nome_non_valido" {
  command = plan

  variables {
    nome = "A-1"
  }

  expect_failures = [
    var.nome,
  ]
}
