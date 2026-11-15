check "docenti_sufficienti" {
  assert {
    condition     = length(var.docenti) >= 2
    error_message = "Meno di due docenti: manca il sostituto."
  }
}
