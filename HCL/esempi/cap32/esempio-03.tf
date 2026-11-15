variable "repliche" {
  type    = number
  default = 2
}

job "saluto" {
  type = "batch"

  group "lavoro" {
    count = var.repliche

    task "eco" {
      driver = "raw_exec"

      config {
        command = "/bin/sh"
        args    = ["-c", "echo Ciao da ${NOMAD_ALLOC_INDEX}"]
      }

      resources {
        cpu    = 50
        memory = 32
      }
    }
  }
}
