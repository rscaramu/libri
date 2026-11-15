output "cartella_presente" {
  value = provider::local::direxists(
    "${path.module}/.terraform"
  )
}

output "anno" {
  value = provider::time::rfc3339_parse(
    "2026-11-15T08:30:00Z"
  ).year
}
