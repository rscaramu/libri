resource "local_file" "chiave" {
  filename = "${path.module}/chiave.txt"
  content  = "segreto"
}

resource "local_file" "servizio" {
  filename = "${path.module}/servizio.txt"
  content  = "avviato"

  # Il servizio legge la chiave all'avvio, ma non ne usa
  # alcun attributo: la dipendenza va dichiarata.
  depends_on = [local_file.chiave]
}
