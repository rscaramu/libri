variable "cartella_dati" {
  type    = string
  default = null
}

resource "docker_container" "web" {
  name  = "web"
  image = "nginx:stable"

  dynamic "volumes" {
    for_each = var.cartella_dati[*]
    content {
      host_path      = volumes.value
      container_path = "/dati"
    }
  }
}
