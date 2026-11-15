variables {
  nome = "a1"
}

run "etichetta_corretta" {
  command = plan

  assert {
    condition     = output.etichetta == "aula-a1"
    error_message = "L'etichetta non ha il prefisso atteso."
  }
}
