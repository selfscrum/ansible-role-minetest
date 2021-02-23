# Backup Project in Open Telekom Cloud

Since Hetzner is not yet providing a cloud object storage service, we wil push our data backups to another place. In this case, it is the Open Telekom Cloud, which has an S3-compatible service that can be provisioned with Terraform, too. 

This service piece is not included in the overall Terraform Cloud provisioning, so you must provide separately before you provision the main project.
