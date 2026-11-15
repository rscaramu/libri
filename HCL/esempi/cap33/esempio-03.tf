# Lettura dei segreti dell'applicazione "registro".
path "secret/data/registro/*" {
  capabilities = ["read"]
}

path "secret/metadata/registro/*" {
  capabilities = ["list"]
}

# Nessun accesso ai segreti della produzione.
path "secret/data/registro/produzione/*" {
  capabilities = ["deny"]
}
