output "public_ip" {
  value = google_compute_instance.web.network_interface.0.access_config.0.nat_ip
}

# output "debug_01" {
#   value = google_compute_address.static.address
# }

# output "debug_02" {
#   value = google_compute_instance.web.network_interface.0.access_config.0.nat_ip
#   # value = google_compute_instance.web.*.network_interface.0.access_config.0.nat_ip
# }
