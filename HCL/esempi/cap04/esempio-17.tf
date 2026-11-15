resource "local_file" "nota" {
  filename        = "nota.txt"
  content         = "testo"
  file_permission = var.riservato ? "0600" : null
}
