variable "zone" {
  type    = list(string)
  default = ["a", "b"]
}

variable "etichette" {
  type    = map(string)
  default = {}
}

variable "porte" {
  type    = set(number)
  default = [80, 443]
}
