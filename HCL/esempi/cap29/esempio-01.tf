terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-south-1"

  default_tags {
    tags = {
      progetto = "registro"
      gestione = "opentofu"
    }
  }
}

data "aws_availability_zones" "zone" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["*ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_vpc" "rete" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "registro-rete"
  }
}

resource "aws_subnet" "pubblica" {
  vpc_id            = aws_vpc.rete.id
  cidr_block        = cidrsubnet(aws_vpc.rete.cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.zone.names[0]
}

resource "aws_security_group" "web" {
  name   = "registro-web"
  vpc_id = aws_vpc.rete.id
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.pubblica.id
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "registro-web"
  }
}

resource "aws_s3_bucket" "documenti" {
  bucket = "scuola-registro-documenti"
}
