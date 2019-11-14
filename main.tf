# Read also the Terraform GCP provider documentation
# https://www.terraform.io/docs/providers/google/getting_started.html


provider "google" {
  credentials = file("C:/Automic/Tools/GCP-key/Demos-ESD-Auto-EMEA-PSL-148d345550fd.json")
  project     = "demos-esd-auto-emea-psl"
  region      = "europe-west3"
}

resource "google_compute_instance" "default" {
  project      = "demos-esd-auto-emea-psl"
  zone         = "europe-west3-c"
  name         = "lau-infrastructure"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "centos-8-v20191018"
    }
  }
  # A default network is created for all GCP projects  
  network_interface {
    network 	  = "default"
#	network       = "${google_compute_network.vpc_network.self_link}"
    access_config {
    }
  }
}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}


#resource "google_compute_network" "vpc_network" {
#  name                    = "default"
#  auto_create_subnetworks = "true"
#}

output "name_output" {
	description = "Instance name"
	value       = "${google_compute_instance.default.*.name[0]}"
}

output "project_output" {
	description = "Project name"
	value       = "${google_compute_instance.default.*.project[0]}"
}

output "internal_ip_output" {
	description = "Internal IP"
	value       = "${google_compute_instance.default.*.network_interface.0.network_ip}"
}

output "external_ip_output" {
	description = "External IP "
	value 		= "${google_compute_instance.default.*.network_interface.0.access_config.0.nat_ip}"
}
