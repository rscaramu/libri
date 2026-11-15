resource "local_file" "orario" {
  filename = "${path.module}/orario.txt"
  content  = "Lezione alle 8:00\n"
}
