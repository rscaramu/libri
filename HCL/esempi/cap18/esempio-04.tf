resource "local_file" "cfg" {
  filename        = "${path.module}/cfg.txt"
  content         = "configurazione"
  file_permission = "0644"

  lifecycle {
    ignore_changes = [file_permission]
  }
}
