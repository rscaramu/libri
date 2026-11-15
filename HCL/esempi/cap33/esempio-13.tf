service "registro-web" {
  policy = "write"
}

service_prefix "" {
  policy = "read"
}

key_prefix "registro/" {
  policy = "read"
}

node_prefix "" {
  policy = "read"
}
