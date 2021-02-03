resource "hcloud_server" "minetest" {
  name        = var.cluster_name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  labels      = var.labels
  ssh_keys    = [ var.ssh_key ]
  user_data   = var.user_data
}

# create disk only if no id passed in
resource "hcloud_volume" "data" {
  count = var.disk_id == "" ? 1 : 0 
  name = format("%s-data-disk", var.cluster_name)
  server_id = hcloud_server.minetest.id
  format = "ext4"
  size = 50
  automount = true
}

# attach disk only if id passed in
resource "hcloud_volume_attachment" "data-to-server" {
  count = var.disk_id == "" ? 0 : 1 
  volume_id = var.disk_id 
  server_id = hcloud_server.minetest.id
  automount = true
}