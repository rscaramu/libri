resource "local_file" "x" {
  filename        = "a.txt"
  content         = "ciao"
  file_permission = "0644"
}
