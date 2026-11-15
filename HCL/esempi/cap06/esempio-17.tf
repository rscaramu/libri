variable "laboratorio" {
  type = object({
    nome       = string
    posti      = optional(number, 24)
    proiettore = optional(bool, false)
  })
  default = {
    nome = "Elettronica"
  }
}
