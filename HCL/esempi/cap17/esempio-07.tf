dynamic "regola" {
  for_each = var.regole
  content {
    nome = regola.value.nome

    dynamic "intervallo" {
      for_each = regola.value.intervalli
      content {
        da = intervallo.value.da
        a  = intervallo.value.a
      }
    }
  }
}
