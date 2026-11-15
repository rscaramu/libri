variable "nome" {
  type        = string
  description = "Persona da salutare."
}

output "saluto" {
  value = "Ciao, ${var.nome}!"
}
