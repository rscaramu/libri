resource "local_file" "registro" {
  filename        = "${path.module}/registro.txt"
  content         = "voci del registro"
  file_permission = "0640"

  lifecycle {
    prevent_destroy = true
    # Permessi gestiti a mano dal tecnico di laboratorio.
    ignore_changes = [file_permission]
  }
}
