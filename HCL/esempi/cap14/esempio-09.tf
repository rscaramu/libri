data "local_file" "configurazione" {
  filename = "${path.module}/scheda.txt"
}

output "contenuto" {
  value = data.local_file.configurazione.content
}
