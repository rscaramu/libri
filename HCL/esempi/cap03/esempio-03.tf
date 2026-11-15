resource "terraform_data" "esempio" {
  input = "valore"

  lifecycle {
    create_before_destroy = true
  }
}
