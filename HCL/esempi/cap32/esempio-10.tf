resource "nomad_job" "registro" {
  jobspec = file("${path.module}/registro.nomad.hcl")
}
