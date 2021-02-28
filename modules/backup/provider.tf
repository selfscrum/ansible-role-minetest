terraform {
  required_providers {
    opentelekomcloud = {
      source = "opentelekomcloud/opentelekomcloud"
    }
  }
}

variable "access_key" {}
variable "secret_key" {}
variable "domain_name" {}

provider "opentelekomcloud" {
  access_key  = var.access_key
  secret_key  = var.secret_key
  domain_name = var.domain_name
  tenant_name = "eu-de"
  auth_url    = "https://iam.eu-de.otc.t-systems.com/v3"
}
