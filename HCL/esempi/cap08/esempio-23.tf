variable "host" {
  type = map(string)
  default = {
    web   = "10.0.0.1"
    db    = "10.0.0.2"
    posta = "10.0.0.3"
  }
}

locals {
  hosts = <<EOT
%{for nome, ip in var.host~}
${ip} ${nome}
%{endfor~}
EOT
}
