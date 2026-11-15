mock_provider "docker" {
  mock_resource "docker_container" {
    defaults = {
      id = "contenitore-finto"
    }
  }
}

variables {
  nome = "prova"
}

run "nome_del_contenitore" {
  command = apply

  assert {
    condition     = output.nome == "web-prova"
    error_message = "Nome inatteso."
  }

  assert {
    condition     = output.id == "contenitore-finto"
    error_message = "Identificativo inatteso."
  }
}
