variable "porta" {
  type    = number
  default = 443
}

variable "origine" {
  type    = string
  default = "0.0.0.0/0"

  validation {
    condition = !(
      var.porta == 22 && var.origine == "0.0.0.0/0"
    )
    error_message = "SSH non va aperto a tutta la rete."
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingresso" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = var.origine
  from_port         = var.porta
  to_port           = var.porta
  ip_protocol       = "tcp"
}
