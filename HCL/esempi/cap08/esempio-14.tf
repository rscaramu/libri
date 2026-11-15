variable "utenti" {
  type    = list(string)
  default = ["anna", "bruno"]
}

locals {
  senza_tilde = <<EOT
Utenti:
%{for u in var.utenti}
- ${u}
%{endfor}
EOT
  con_tilde   = <<EOT
Utenti:
%{~for u in var.utenti}
- ${u}
%{~endfor}
EOT
}
