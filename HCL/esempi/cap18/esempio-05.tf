resource "terraform_data" "versione" {
  input = var.versione_config
}

resource "local_file" "cfg" {
  filename = "${path.module}/cfg.txt"
  content  = "configurazione"

  lifecycle {
    replace_triggered_by = [terraform_data.versione]
  }
}
