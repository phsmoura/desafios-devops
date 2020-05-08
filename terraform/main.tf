provider "google" {
  # Set the below environment variables:
  # - GOOGLE_CREDENTIALS
  # - GOOGLE_PROJECT
  # - GOOGLE_REGION
  # or configure directly below. Docs:
  # - https://www.terraform.io/docs/providers/google/
  # - https://console.cloud.google.com/apis/credentials/serviceaccountkey?project=<PROJECT ID>&authuser=1

  credentials = file("credencials/account.json")
  project     = var.gcp_project
  region      = var.gcp_region
}

# resource "google_compute_address" "static" {
#   name = "ipv4-address"
# }

resource "google_compute_instance" "web" {
  name         = var.name
  machine_type = var.gcp_size
  zone         = var.gcp_zone

  # # Everytime you run this code, a new ssh key will be included on metadada even if the user already exists
  # metadata = {
  #   ssh-keys = "${var.gcp_username}:${file(var.gcp_public_key_path)}"
  # }

  boot_disk {
    initialize_params {
      image = var.gcp_image
    }
  }

  network_interface {
    network = var.gcp_network

    access_config {
      # nat_ip = data.google_compute_address.static.address
    }
  }

  # should wait 1m20s to connect
  provisioner "remote-exec" {
    connection {
      # Issues with host variable. Solved:
      # https://github.com/hashicorp/terraform/issues/20816
      host        = google_compute_instance.web.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.gcp_username
      private_key = file(var.gcp_private_key_path)
      agent       = false
    }

    inline = [
      "sudo curl -sSL https://get.docker.com/ | sh",
      "sudo usermod -aG docker `echo $USER`",
      # using docker module to provide containers would be better for maintenance
      "sudo docker run -d -p 80:80 httpd:2.4.43"
    ]
  }

}

# Creating firewall rules
resource "google_compute_firewall" "allow-https-https" {
  name        = "${var.name}-allow-https-https"
  network     = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-ssh-ip-range" {
  name        = "${var.name}-allow-ssh-ip-range"
  network     = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.client_ip}"]
}

# # Configuring docker on the on instance
# provider "docker" {
#   # unable to parse docker host
#   host = "ssh://${var.gcp_username}@${google_compute_instance.web.network_interface.0.access_config.0.nat_ip}:22"
# }
#
# # Create apache container
# resource "docker_container" "web" {
#   image = "${docker_image.apache}"
#   name  = "apache"
# }
#
# resource "docker_image" "apache" {
#   name = "httpd:2.4.43"
# }
