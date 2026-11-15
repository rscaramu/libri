resource "local_file" "elenco" {
  filename = "${path.module}/elenco.txt"
  content  = join("\n", var.nomi)

  lifecycle {
    precondition {
      condition     = length(var.nomi) > 0
      error_message = "Serve almeno un nome."
    }

    postcondition {
      condition     = self.content != ""
      error_message = "Il file non deve risultare vuoto."
    }
  }
}
