data "aws_ami" "web" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:ruolo"
    values = ["web"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.web.id
  instance_type = "t3.micro"
}
