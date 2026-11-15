terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "postazioni" {
  type    = number
  default = 3
}

resource "local_file" "postazione" {
  count    = var.postazioni
  filename = "${path.module}/pc-${count.index + 1}.txt"
  content  = "Postazione numero ${count.index + 1}\n"
}

output "file_creati" {
  value = local_file.postazione[*].filename
}
