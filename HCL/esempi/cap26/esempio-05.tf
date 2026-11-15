run "contenuto_con_posti" {
  command = plan

  variables {
    posti = 30
  }

  assert {
    condition = strcontains(
      local_file.scheda.content,
      "30 posti"
    )
    error_message = "Il contenuto non riporta i posti."
  }
}
