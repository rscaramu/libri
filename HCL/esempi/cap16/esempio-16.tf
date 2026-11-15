resource "local_file" "backup" {
  count    = var.ambiente == "produzione" ? 1 : 0
  filename = "${path.module}/backup.txt"
  content  = "Backup attivo\n"
}

output "file_backup" {
  value = one(local_file.backup[*].filename)
}
