resource "vault_policy" "lettura" {
  for_each = toset(["registro", "orario"])

  name = "lettura-${each.key}"
  policy = templatefile("${path.module}/lettura.hcl.tftpl", {
    applicazione = each.key
  })
}
