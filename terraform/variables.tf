# provider variables
variable "gcp_project" {
  description = "Google Cloud Platform project"
  # better use env variable to make it static
  default     = "my_project"
}

variable "gcp_region" {
  description = "Google Cloud Platform's selected region"
  # default     = "us-central1"
}

# compute instance variables
variable "name" {
  description = "Name of the Compute Engine instance(s)."
  default     = "test"
}

variable "gcp_size" {
  # See also:
  #   $ gcloud compute machine-types list
  description = "Google Cloud Platform's selected machine size"
  default = "n1-standard-1"
}

variable "gcp_zone" {
  description = "Google Cloud Platform's selected zone"
  default     = "us-central1-a"
}

variable "gcp_image" {
  # See also: https://cloud.google.com/compute/docs/images
  description = "Google Cloud Platform OS"
  # default     = "ubuntu-os-cloud/ubuntu-1604-lts"
  default     = "debian-cloud/debian-9"
}

variable "gcp_network" {
  description = "Google Cloud Platform's selected network"
  default     = "default"
}

# firewall variables, it also uses name and network variables
variable "client_ip" {
  description = "IP address of the client machine"
  # default     = "0.0.0.0/0"
}

# for ssh connection
variable "gcp_username" {
  description = "Google Cloud Platform SSH username"
  # better use env variable to make it static
  default = "my_username"
}

variable "gcp_public_key_path" {
  description = "Path to file containing public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "gcp_private_key_path" {
  description = "Path to file containing private key"
  default     = "~/.ssh/id_rsa"
}
