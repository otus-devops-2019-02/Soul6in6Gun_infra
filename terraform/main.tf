terraform {
# Версия terraform
required_version = ">=0.11,<0.12"
}
provider "google" {
# Версия провайдера
version = "2.0.0"
# ID проекта
project = "${var.project}"
region = "${var.region}"
}

resource "google_compute_firewall" "firewall_ssh" {
name = "allow-ssh-default"
network = "default"

allow {
	protocol = "tcp"
	ports = ["22"]
}
	source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_project_metadata" "default" {
	metadata {
		ssh-keys = <<EOF
		appuser:${file(var.public_key_path)}
		appuser1:${file(var.public_key_path)}
		appuser2:${file(var.public_key_path)}
	EOF
	}
}

resource "google_compute_instance" "app" {
	name         = "reddit-app-${count.index}"
	count        = "${var.count}"
	machine_type = "g1-small"
	zone         = "${var.region}-${var.zone}"

	boot_disk {
		initialize_params {
		image = "${var.disk_image}"
		}
}
	tags = ["reddit-app"]
	network_interface {
	network       = "default"
	access_config = {}
	}

metadata {
ssh-keys = "appuser:${file(var.public_key_path)}"
}

	connection {
		type        = "ssh"
		user        = "appuser"
		agent       = false
		private_key = "${file(var.private_key_path)}"
	}

	provisioner "file" {
		source      = "files/puma.service"
		destination = "/tmp/puma.service"
	}

	provisioner "remote-exec" {
		script = "files/deploy.sh"
	}
}

resource "google_compute_firewall" "firewall_puma" {
	name    = "allow-puma-default"
	network = "default"

	allow {
		protocol = "tcp"
	ports    = ["9292"]
	}

	source_ranges = ["0.0.0.0/0"]
	target_tags   = ["reddit-app"]
}
