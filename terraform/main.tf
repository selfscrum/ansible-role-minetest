terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}

variable "access_token" {}

variable "env_name"  { }
variable "env_stage" { }
variable "location" { }
variable "system_function" {}
variable "server_image" {}
variable "server_type" {}
variable "keyname" {} 
variable "network_zone" {}
variable "mt_version" {}
variable "mt_server_name" {}
variable "mt_server_description" {}
variable "mt_bind_address" {}
variable "mt_bind_port" {}
variable "mt_admin_name" {}

variable "default_password" {}

provider "hcloud" {
  token = var.access_token
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE MINETEST SERVER
# ---------------------------------------------------------------------------------------------------------------------

module "minetest_server" {
  source = "./modules/minetest_server"
  cluster_name      = format("%s-%s-server",var.env_stage, var.env_name)
  image             = var.server_image
  server_type       = var.server_type
  location          = var.location
  labels            = {
                      "Name"   = var.env_name
                      "Stage"  = var.env_stage
  }
  ssh_key           = var.keyname
  user_data         = templatefile (
# ---------------------------------------------------------------------------------------------------------------------
# THE MULTIPART/MIXED USER DATA SCRIPT THAT WILL RUN ON THE SERVER INSTANCE WHEN IT'S BOOTING
# ---------------------------------------------------------------------------------------------------------------------
                      "${path.module}/user-data-server.mm",
                        {
                        hcloud_token           = var.access_token
                        mt_default_password    = var.default_password
                        mt_version             = var.mt_version
                        mt_server_name         = var.mt_server_name
                        mt_server_description  = var.mt_server_description
                        mt_bind_address        = var.mt_bind_address
                        mt_bind_port           = var.mt_bind_port
                        mt_admin_name          = var.mt_admin_name
                        }
                      )
}

