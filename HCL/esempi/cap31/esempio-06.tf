packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.3"
    }
  }
}

variable "regione" {
  type    = string
  default = "eu-south-1"
}

locals {
  data = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "amazon-ebs" "ubuntu" {
  region        = var.regione
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"
  ami_name      = "lab-web-${local.data}"

  source_ami_filter {
    most_recent = true
    owners      = ["099720109477"]

    filters = {
      name = "*ubuntu-noble-24.04-amd64-server-*"
    }
  }

  tags = {
    ruolo    = "web"
    gestione = "packer"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }

  provisioner "file" {
    source      = "file/index.html"
    destination = "/tmp/index.html"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/index.html /var/www/html/",
    ]
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}
