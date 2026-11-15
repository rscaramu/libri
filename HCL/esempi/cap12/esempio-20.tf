variable "cidr" {
  type    = string
  default = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "Il valore non e' un blocco CIDR valido."
  }
}
