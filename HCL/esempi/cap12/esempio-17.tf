locals {
  testo  = <<-EOT
    {"nome": "srv1", "dischi": [{"gb": 50}, {"gb": 200}]}
  EOT
  server = jsondecode(local.testo)
}
