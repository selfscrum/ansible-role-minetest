output "server_name" {
  value       = format("%s-%s-server",var.env_stage, var.env_name)
  description = "The host name of the minetest server"
}
