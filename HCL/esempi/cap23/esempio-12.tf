import {
  for_each = var.identificativi
  to       = random_uuid.elenco[each.key]
  id       = each.value
}
