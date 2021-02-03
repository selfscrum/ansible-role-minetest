resource "hcloud_server" "minetest" {
  name        = var.cluster_name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  labels      = var.labels
  ssh_keys    = [ var.ssh_key ]
  user_data   = var.user_data
}

resource "hcloud_volume" "data" {
  count = var.disk_id == "" ? 1 : 0 
  name = format("%s-data-disk", var.cluster_name)
  location = var.location
  size = 50
}

resource "hcloud_volume_attachment" "data-to-server" {
  volume_id = var.disk_id == "" ? hcloud_volume.data[0].id : var.disk_id 
  server_id = hcloud_server.minetest.id
  automount = true
}