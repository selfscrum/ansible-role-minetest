terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}

variable "access_token" {}

provider "hcloud" {
  token = var.access_token
}
