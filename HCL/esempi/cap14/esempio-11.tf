resource "terraform_data" "avviso" {
  provisioner "local-exec" {
    command = "echo creato >> registro.txt"
  }
}
