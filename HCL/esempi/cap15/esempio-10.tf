resource "local_file" "indice" {
  filename   = "${path.module}/indice.txt"
  content    = "vedi ${path.module}/dati.txt"
  depends_on = [local_file.dati]
}
