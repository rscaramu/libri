resource "random_pet" "nome" {
  length = 2

  lifecycle {
    create_before_destroy = true
  }
}
