resource "docker_container" "web" {
  name  = "web"
  image = "nginx:stable"

  ports {
    internal = 80
    external = 8080
  }

  ports {
    internal = 443
    external = 8443
  }
}
