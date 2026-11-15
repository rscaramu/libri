variable "aule" {
  type = list(object({
    nome  = string
    piano = number
  }))
  default = [
    { nome = "A1", piano = 0 },
    { nome = "A2", piano = 0 },
    { nome = "B1", piano = 1 },
  ]
}
