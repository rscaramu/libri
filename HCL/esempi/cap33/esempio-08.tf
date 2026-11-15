ui = true

storage "raft" {
  path    = "/srv/vault/dati"
  node_id = "vault-1"
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault/tls/vault.crt"
  tls_key_file  = "/etc/vault/tls/vault.key"
}

api_addr     = "https://vault.scuola.example:8200"
cluster_addr = "https://vault.scuola.example:8201"
