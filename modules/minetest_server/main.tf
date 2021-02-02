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
  name = format("%s-data-disk", car.cluster_name)
  size = 25
}

resource "hcloud_volume_attachment" "data-to-server" {
  volume_id = hcloud_volume.data.id
  server_id = hcloud_server.minetest.id
  automount = true
}