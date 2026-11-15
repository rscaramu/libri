variable "nomi" {
  type    = list(string)
  default = ["anna", "bruno", "carla"]
}

variable "voti" {
  type = map(number)
  default = {
    anna  = 8
    bruno = 5
    carla = 7
  }
}
