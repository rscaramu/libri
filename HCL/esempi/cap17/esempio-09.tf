resource "docker_container" "web" {
  name  = "web"
  image = "nginx:stable"

  dynamic "ports" {
    for_each = { http = 80, https = 443 }
    iterator = porta
    content {
      internal = porta.value
      external = porta.value
    }
  }
}
