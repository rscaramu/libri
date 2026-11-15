run "nome_con_cifra_iniziale" {
  command = plan

  variables {
    nome = "1a"
  }

  expect_failures = [
    var.nome,
  ]
}
