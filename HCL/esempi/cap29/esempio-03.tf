terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = "scuola-registro"
  region  = "europe-west8"
}

resource "google_compute_network" "rete" {
  name                    = "registro-rete"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "servizi" {
  name          = "registro-servizi"
  network       = google_compute_network.rete.id
  ip_cidr_range = "10.20.1.0/24"
  region        = "europe-west8"
}

resource "google_compute_instance" "web" {
  name         = "registro-web"
  machine_type = "e2-micro"
  zone         = "europe-west8-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.servizi.id
  }

  labels = {
    progetto = "registro"
    gestione = "opentofu"
  }
}

resource "google_storage_bucket" "documenti" {
  name     = "scuola-registro-documenti"
  location = "EUROPE-WEST8"
}
