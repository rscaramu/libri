run "posti_predefiniti" {
  command = plan

  variables {
    nome = "b2"
  }

  assert {
    condition = strcontains(
      local_file.scheda.content,
      "24 posti"
    )
    error_message = "Attesi 24 posti come predefinito."
  }
}
