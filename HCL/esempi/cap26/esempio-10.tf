run "prepara" {
  module {
    source = "./tests/preparazione"
  }
}

run "usa_il_modulo" {
  variables {
    cartella = run.prepara.cartella
  }

  assert {
    condition     = output.file != ""
    error_message = "Nessun file prodotto."
  }
}
