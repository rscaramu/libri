data "terraform_remote_state" "dati" {
  backend = "local"

  config = {
    path = "/srv/stati/dati.tfstate"
  }
}

output "host_db" {
  value = data.terraform_remote_state.dati.outputs.host_db
}
