resource "local_file" "turno" {
  count    = 5
  filename = "${path.module}/turno-${count.index + 1}.txt"
  content  = "${count.index + 1}\n"
}
