service {
  name = "registro-web"
  port = 8080
  tags = ["web", "collaudo"]

  check {
    name     = "http"
    http     = "http://localhost:8080/"
    interval = "10s"
    timeout  = "2s"
  }
}
