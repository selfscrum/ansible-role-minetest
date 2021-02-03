# Manage your Terraform Cloud Workspace with ... Terraform!

You can create the workspace for your main project in the cloud with terraform because there is a terraform cloud provider that allows to remote-control Terraform Cloud. 

Just start this local terraform project, and the cloud setup will be done, when you have your ~/.terraformrc API token stored properly. You have to connect to your gitlab account though, and the sensitive variables must be inserted manually in the terraform cloud environment.

