variable "scuola" {
  type        = string
  description = "Nome dell'istituto."
  default     = "Vallauri"
}

variable "aule" {
  type    = number
  default = 12
}

locals {
  etichetta = "${var.scuola}-${var.aule}"
}

output "etichetta" {
  value = local.etichetta
}
