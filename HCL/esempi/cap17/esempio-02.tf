terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

variable "porte" {
  type = list(object({
    interna = number
    esterna = number
  }))
  default = [
    { interna = 80, esterna = 8080 },
    { interna = 443, esterna = 8443 },
  ]
}

resource "docker_container" "web" {
  name  = "web"
  image = "nginx:stable"

  dynamic "ports" {
    for_each = var.porte
    content {
      internal = ports.value.interna
      external = ports.value.esterna
    }
  }
}
