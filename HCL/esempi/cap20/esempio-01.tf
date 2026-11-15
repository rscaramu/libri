module "rete" {
  source = "git::https://example.com/infra/moduli.git//rete?ref=v1.4.0"

  nome = "laboratori"
  cidr = "10.20.0.0/16"
}
