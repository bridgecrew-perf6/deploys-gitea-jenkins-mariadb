terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("/home/nikolos/Documents/cv/terraform/project-test-354609-879dfa8d0413.json")

  project = "project-test-354609"
  region  = "europe-north1"
  zone    = "europe-north1-a"
}

resource "google_compute_network" "terraform-network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "web"
  machine_type = "e2-small"
  tags         = ["my-firewall-rule"]
  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  metadata_startup_script = "sudo apt-get update -y; sudo apt-get install -yq screenfetch"

  network_interface {
    network = "terraform-network"
    access_config {
    }
  }
}


resource "google_compute_firewall" "my-firewall-rule" {
  project     = "project-test-354609"
  name        = "my-firewall-rule"
  network     = "terraform-network"
  description = "Creates firewall rule"

  allow {
    protocol  = "tcp"
    ports     = ["80", "22", "8080", "33", "3000","443"]
  }
  target_tags = ["my-firewall-rule"]
  source_ranges = ["0.0.0.0/0"]

}

output "external-ip" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}

output "public-ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}

output "name-machine" {
  value = google_compute_instance.vm_instance.name
}
