resource "docker_container" "web" {
  name  = "web"
  image = "nginx:stable"

  dynamic "ports" {
    for_each = var.porte
    iterator = p
    content {
      internal = p.value.interna
      external = p.value.esterna
    }
  }
}
