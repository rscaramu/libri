variable "nome" {
  type    = string
  default = "web"
}

variable "porte" {
  type    = list(number)
  default = [80, 443]
}

variable "debug" {
  type    = bool
  default = true
}
