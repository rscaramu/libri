resource "local_file" "dati" {
  filename = "${path.module}/dati.txt"
  content  = "importante"

  lifecycle {
    prevent_destroy = true
  }
}
