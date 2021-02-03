output "minetest_disk_id" {
  value       = hcloud_volume.data.id
  description = "The ID of the created disk"
}
