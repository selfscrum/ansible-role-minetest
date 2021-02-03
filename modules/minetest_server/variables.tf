variable "cluster_name" {
  description = "The name of the server (e.g. minetest). This variable is used to namespace all resources created by this module."
  type        = string
}

variable "user_data" {
  description = "A User Data script to execute while the server is booting."
  type        = string
}

variable "image" {
    description = "The image ID that will be used to create the instance"
    type = string
}

variable "server_type" {
    description = "The Hetzner server type that will be used to create the instance"
    type = string
}

variable "location" {
    description = "The Hetzner location code that will be used to create the instance"
    type = string
}

variable "ssh_key" {
    description = "The public key that will be used to check ssh access"
    type = string
}

variable "disk_id" {
    description = "optional id of an already existing disk"
    type = string
    default = ""
}

variable "labels" {
    description = "Labels that are set at the instance"
    type = map(string)
}

