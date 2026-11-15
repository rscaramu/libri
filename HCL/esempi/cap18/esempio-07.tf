variable "posti" {
  type    = number
  default = 24

  validation {
    condition     = var.posti > 0 && var.posti <= 30
    error_message = "I posti devono essere fra 1 e 30."
  }

  validation {
    condition     = var.posti % 2 == 0
    error_message = "Il numero di posti deve essere pari."
  }
}
