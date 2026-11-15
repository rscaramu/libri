resource "local_file" "registro" {
  filename   = "${path.module}/registro.txt"
  content    = "pronto"
  depends_on = [local_file.server]
}
