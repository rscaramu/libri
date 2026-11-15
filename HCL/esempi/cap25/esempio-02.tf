resource "local_file" "scheda" {
  for_each = var.laboratori

  filename        = "${path.module}/${each.key}.txt"
  content         = each.value.descrizione
  file_permission = "0644"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [local_file.indice]
}
