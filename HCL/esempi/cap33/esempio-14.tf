data "consul_keys" "registro" {
  key {
    name = "indirizzo_db"
    path = "registro/db/indirizzo"
  }
}

locals {
  indirizzo_db = data.consul_keys.registro.var.indirizzo_db
}
