variable "repliche" {
  type    = number
  default = 3
}

variable "versione" {
  type    = string
  default = "1.27"
}

job "registro" {
  datacenters = ["dc1"]
  type        = "service"

  group "web" {
    count = var.repliche

    network {
      port "http" {
        to = 80
      }
    }

    service {
      name     = "registro-web"
      port     = "http"
      provider = "nomad"

      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    update {
      max_parallel = 1
      auto_revert  = true
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:${var.versione}"
        ports = ["http"]
      }

      env {
        AMBIENTE = "collaudo"
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
