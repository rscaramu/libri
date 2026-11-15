locals {
  prefisso = "${var.progetto}-${var.ambiente}"

  etichette = {
    progetto = var.progetto
    ambiente = var.ambiente
    gestione = "opentofu"
  }
}
