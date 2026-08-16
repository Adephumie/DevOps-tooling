# Terraform: Infrastructure Provisioning Tool

Terraform is used for infrastructure provisioning and management and not configuration of that infrastructure.
We will find a typical use case where we configured the server created using Terraform with the user data.

Ansible, on the other hand, works perfectly for infrastructure configuration.

## Provisioners

Are alternative to using the user_data parameter in the terraform config file.

Remote-exec provisioner allows us to connect to the remote server to invoke scripts on it.

Provisioners are not recommended by Terraform. They should only be used as a last resort.
  The reason is that provisioners are not idempotent, meaning that they can cause issues if 
  the resource is recreated or updated. 
  Use provisioners only when there is no other way to achieve the desired outcome.
  Tools like Ansible, Chef, or Puppet are better suited for configuration management and 
  should be used instead of provisioners whenever possible.

There's a local terraform block that can be used in place of local-exec provisioner.