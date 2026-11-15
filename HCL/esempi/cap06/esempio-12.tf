locals {
  prefisso  = "${var.scuola}-${var.ambiente}"
  nome_rete = "${local.prefisso}-rete"
  etichette_comuni = {
    scuola   = var.scuola
    ambiente = var.ambiente
  }
}
