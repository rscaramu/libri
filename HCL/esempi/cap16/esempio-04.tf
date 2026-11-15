variable "aule" {
  type    = list(string)
  default = ["a1", "a2", "b1"]
}

resource "local_file" "aula" {
  count    = length(var.aule)
  filename = "${path.module}/${var.aule[count.index]}.txt"
  content  = "Aula ${var.aule[count.index]}\n"
}
