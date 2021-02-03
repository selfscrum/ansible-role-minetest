#
# disk/main.tf - create an independent disk
#

resource "hcloud_volume" "data" {
  name = var.cluster_name
  location = var.location
  size = var.disk_size
  format = var.fs_type
}
