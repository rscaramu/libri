variable "server" {
  type = object({
    nome  = string
    porta = optional(number, 8080)
    tag   = optional(map(string), {})
  })
  default = {
    nome = "web"
  }
}
