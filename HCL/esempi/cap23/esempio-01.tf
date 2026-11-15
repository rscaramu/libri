terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "nuovo" {}

moved {
  from = random_pet.vecchio
  to   = random_pet.nuovo
}
