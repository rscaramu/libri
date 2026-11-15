resource "docker_container" "app" {
  name  = "app"
  image = "nginx:stable"

  volumes {
    host_path      = "/srv/dati"
    container_path = "/dati"
  }

  volumes {
    host_path      = "/srv/log"
    container_path = "/var/log/app"
  }
}
