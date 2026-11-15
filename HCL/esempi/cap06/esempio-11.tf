variable "ambiente" {
  type    = string
  default = "sviluppo"

  validation {
    condition = contains(
      ["sviluppo", "collaudo", "produzione"],
      var.ambiente
    )
    error_message = "Ambiente non riconosciuto."
  }
}
