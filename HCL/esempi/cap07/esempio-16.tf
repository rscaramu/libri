variable "studenti" {
  type    = number
  default = 80
}

locals {
  locale = (
    var.studenti <= 30 ? "aula" :
    var.studenti <= 120 ? "aula magna" :
    "palestra"
  )
}
