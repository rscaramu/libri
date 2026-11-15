variable "classe" {
  type    = string
  default = "5A"
}

locals {
  messaggio = "Ciao ${var.classe}"
}
