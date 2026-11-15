data "local_file" "riletto" {
  filename = local_file.estratto.filename
}

output "contenuto" {
  value = data.local_file.riletto.content
}
