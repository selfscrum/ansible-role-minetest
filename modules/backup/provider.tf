terraform {
  required_providers {
    opentelekomcloud = {
      source = "opentelekomcloud/opentelekomcloud"
    }
  }
}

provider "opentelekomcloud" {
  access_key  = "9MGSZQXOAZIMVIUV02O8"
  secret_key  = "bzKcZKxr1OjumjFo22xyJOGS69WtBnqkisE5j8st"
  domain_name = "OTC00000000001000054227"
  tenant_name = "eu-de"
  auth_url    = "https://iam.eu-de.otc.t-systems.com/v3"
}
