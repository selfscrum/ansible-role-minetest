variable  "access_key" {
    description = "Telekom AK"
}
variable "secret_key" {
    description = "Telekom SK"
}
variable "account_name" {
    description = "Telekom domain name (use OTC000..., without the '-EU-DE-' middle part)"
}

variable "domain_name" {
    description = "domain of the s3 server. equivalents to S3_HOSTNAME"
}

