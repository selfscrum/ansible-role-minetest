#
# disk/main.tf - create an independent disk
#

module "disk" {
  source = "./disk"
  cluster_name = var.cluster_name
  disk_size = var.disk_size
  fs_type = var.fs_type
  location = var.location
  labels = var.labels
}
