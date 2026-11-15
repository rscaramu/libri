terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

variable "documenti" {
  type = map(string)
  default = {
    "leggimi.txt" = "Istruzioni per il laboratorio"
    "orario.txt"  = "Lunedi 8-13"
  }
}

data "archive_file" "pacco" {
  type        = "zip"
  output_path = "${path.module}/pacco.zip"

  dynamic "source" {
    for_each = var.documenti
    content {
      filename = source.key
      content  = source.value
    }
  }
}

output "dimensione" {
  value = data.archive_file.pacco.output_size
}
