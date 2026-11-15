resource "esempio_base_dati" "principale" {
  nome = "registro"

  timeouts {
    create = "60m"
    delete = "30m"
  }
}
