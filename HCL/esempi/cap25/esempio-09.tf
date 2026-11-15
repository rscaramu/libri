resource "local_file" "nota" {
  for_each = var.note

  filename = "${path.module}/${each.key}.txt"
  content  = each.value

  lifecycle {
    prevent_destroy = true
  }
}
