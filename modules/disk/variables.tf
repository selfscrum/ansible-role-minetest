variable "cluster_name" {
  description = "The name of the disk. This variable is used to namespace all resources created by this module."
  type        = string
  default     = "minetest_isolated_disk"
}

variable "disk_size" {
    description = "Storage size of the volume in GB"
    default = 50
}

variable "fs_type" {
    description = "Filesystem Type for the disk"
    type = string
    default = "ext4"
}

variable "location" {
    description = "The Hetzner location code that will be used to create the disk"
    type = string
    default = "nbg1"
}

variable "labels" {
    description = "Labels that are set at the instance"
    type = map(string)
    default = {
        "Name"   = "minetest_isolated_disk"
        "Stage"  = "dev"
    }

}

