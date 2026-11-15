locals {
  motd = templatefile("${path.module}/motd.tftpl", {
    nome    = "srv01"
    servizi = ["web", "posta"]
  })
}
