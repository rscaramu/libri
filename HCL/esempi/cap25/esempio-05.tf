locals {
  etichette_comuni = {
    progetto  = var.progetto
    ambiente  = var.ambiente
    gestione  = "opentofu"
    sorgente  = "infra/registro"
    referente = var.referente
  }
}
