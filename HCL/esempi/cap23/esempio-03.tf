resource "random_pet" "lista" {
  for_each = toset(["a", "b"])
}

moved {
  from = random_pet.lista[0]
  to   = random_pet.lista["a"]
}

moved {
  from = random_pet.lista[1]
  to   = random_pet.lista["b"]
}
