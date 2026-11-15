variable "classe" {
  type = string

  validation {
    condition     = can(regex("^[1-5][A-Z]$", var.classe))
    error_message = "Formato atteso: 1-5 e lettera, es. 5A."
  }
}
