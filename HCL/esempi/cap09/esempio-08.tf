variable "server" {
  type = list(object({
    nome  = string
    ruolo = string
    cpu   = number
  }))
  default = [
    { nome = "srv1", ruolo = "web", cpu = 2 },
    { nome = "srv2", ruolo = "web", cpu = 4 },
    { nome = "srv3", ruolo = "db", cpu = 8 },
  ]
}

locals {
  per_nome = { for s in var.server : s.nome => s }
}
