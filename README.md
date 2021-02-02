# ansible-role-minetest

Provide a stable one-shop-stop routine to install a Hetzner cloud machine with an immutable minetest base installation and merge optional mod projects.

## Install in Terraform Cloud

Prerequisite: you need 
* a Terraform Cloud account
* a git account that you can connect with Terraform Cloud
* a local terraform binary of at least 0.13.x.
* a local ~/.terraformrc file with an API Token set up to connect to Terraform Cloud.

* Checkout this project then go to `modules/workspace`.
* Run `terraform init`
* Run `terraform apply`. The future provisioning workspace will now be created in Terraform Cloud.

