variable "nome" {
  type        = string
  description = "Persona da salutare."
}

output "messaggio" {
  description = "Il saluto composto."
  value       = "Buongiorno, ${var.nome}"
}
