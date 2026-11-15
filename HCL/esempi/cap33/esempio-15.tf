path "secret/data/orario/*" {
  capabilities = ["create", "read", "update"]
}

path "secret/metadata/orario/*" {
  capabilities = ["list"]
}

path "secret/data/orario/admin" {
  capabilities = ["deny"]
}
