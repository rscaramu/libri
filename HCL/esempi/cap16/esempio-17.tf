variable "ambienti" {
  type    = list(string)
  default = ["dev", "test", "prod"]
}

resource "local_file" "ambiente" {
  count    = length(var.ambienti)
  filename = "${path.module}/${var.ambienti[count.index]}.txt"
  content  = var.ambienti[count.index]
}
