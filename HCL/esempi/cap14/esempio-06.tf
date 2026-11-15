resource "random_password" "db" {
  length  = 16
  special = false
}
