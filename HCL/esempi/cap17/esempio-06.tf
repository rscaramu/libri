dynamic "healthcheck" {
  for_each = var.con_controllo ? [1] : []
  content {
    test     = ["CMD", "curl", "-f", "http://localhost/"]
    interval = "30s"
  }
}
