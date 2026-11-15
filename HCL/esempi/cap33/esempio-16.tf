service {
  name = "orario-api"
  port = 9000
  tags = ["api"]

  check {
    name     = "salute"
    http     = "http://localhost:9000/salute"
    interval = "15s"
    timeout  = "3s"
  }
}
