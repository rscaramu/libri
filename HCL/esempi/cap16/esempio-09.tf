output "nomi_file" {
  value = [for k, r in local_file.aula : r.filename]
}

output "nomi_file_bis" {
  value = values(local_file.aula)[*].filename
}
