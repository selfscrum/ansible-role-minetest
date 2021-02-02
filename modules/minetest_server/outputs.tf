output "minetest_server_ip" {
  value       = hcloud_server.minetest.ipv4_address
  description = "The host IP of the minetest server"
}
