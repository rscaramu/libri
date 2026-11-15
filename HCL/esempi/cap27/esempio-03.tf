terraform {
  encryption {
    key_provider "pbkdf2" "chiave" {
      passphrase = var.frase_stato
    }

    method "aes_gcm" "metodo" {
      keys = key_provider.pbkdf2.chiave
    }

    state {
      method = method.aes_gcm.metodo
    }

    plan {
      method = method.aes_gcm.metodo
    }
  }
}

variable "frase_stato" {
  type      = string
  sensitive = true
}
