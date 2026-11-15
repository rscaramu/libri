resource "local_file" "server" {
  for_each = { for s in var.server : s.nome => s }
  filename = "${path.module}/${each.key}.txt"
  content  = "cpu: ${each.value.cpu}\n"
}
