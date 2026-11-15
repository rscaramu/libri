packer {
  required_version = ">= 1.10.0"
}

variable "scuola" {
  type    = string
  default = "vallauri"
}

variable "versione" {
  type    = string
  default = "1.0.0"
}

locals {
  nome = "${var.scuola}-lab-${var.versione}"
}

source "file" "motd" {
  content = "Benvenuti nel laboratorio ${upper(var.scuola)}\n"
  target  = "uscita/motd-${local.nome}.txt"
}

source "null" "controllo" {
  communicator = "none"
}

build {
  name    = "laboratorio"
  sources = ["source.file.motd", "source.null.controllo"]

  provisioner "shell-local" {
    only   = ["null.controllo"]
    inline = ["echo Preparazione di ${local.nome}"]
  }

  post-processor "manifest" {
    output = "uscita/manifest.json"
  }
}
