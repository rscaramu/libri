resource "terraform_data" "versione" {
  input = var.versione_app

  triggers_replace = [
    var.ambiente,
  ]
}
