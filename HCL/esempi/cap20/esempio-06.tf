module "dns" {
  source = "git::https://example.com/infra/moduli.git//dns?ref=v2.1.0"
  zona   = "scuola.example"
}
