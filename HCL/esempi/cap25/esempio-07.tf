variable "dimensione_disco_gb" {
  type        = number
  description = "Dimensione del disco dati, in gigabyte."
}

variable "cifrato" {
  type        = bool
  description = "Se vero, il disco viene cifrato."
  default     = true
}

resource "local_file" "registro" {
  filename = "registro.txt"
  content  = "x"
}
