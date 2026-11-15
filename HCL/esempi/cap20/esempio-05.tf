module "nomi" {
  source   = "./modules/nomi"
  progetto = "registro"
  ambiente = "produzione"
}

resource "local_file" "nota" {
  filename = "${path.module}/${module.nomi.prefisso}-nota.txt"
  content  = jsonencode(module.nomi.etichette)
}
