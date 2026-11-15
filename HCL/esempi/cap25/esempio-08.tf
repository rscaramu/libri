resource "local_file" "nota" {
  content = each.value
  lifecycle {
    prevent_destroy = true
  }
  filename = "${path.module}/${each.key}.txt"
  for_each = var.note
}
