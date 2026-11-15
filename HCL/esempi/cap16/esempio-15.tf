variable "utenti" {
  type = map(string)
  default = {
    anna  = "docente"
    bruno = "tecnico"
  }
}

resource "local_file" "utente" {
  for_each = var.utenti
  filename = "${path.module}/${each.key}.txt"
  content  = "Ruolo: ${each.value}\n"
}

output "file_per_utente" {
  value = { for k, r in local_file.utente : k => r.filename }
}
