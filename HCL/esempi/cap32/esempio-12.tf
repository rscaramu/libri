config {
  command = "/bin/sh"
  args = [
    "-c",
    "echo ${local.messaggio} da ${NOMAD_ALLOC_INDEX}",
  ]
}
