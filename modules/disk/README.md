# Isolated disk project

If you consider your minetest worlds valuable, you may want to manage the disk independently from the the server. Thus, you can be sure that your data survives even if you destroy the server or the main terrraform project by incident.

Just start this script here with local terraform. To access the cloud, create a .tfvars file with your Hetzner access token, named `account_token`.  put the resulting `minetest_disk_id` in the `disk_id` variable of the main terraform project.

Location is set to default `nbg1`. Change it if your server resides in another Hetzner location.

The disk module as such is nested to allow dual use as terraform module and as standalone workspace.