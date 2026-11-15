locals {
  modello = templatefile("${path.module}/scheda.tftpl", {
    nome = var.nome
  })
}
