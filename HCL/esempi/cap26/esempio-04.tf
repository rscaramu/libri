run "crea_davvero" {
  command = apply

  assert {
    condition     = fileexists(local_file.scheda.filename)
    error_message = "Il file non e' stato creato."
  }
}
