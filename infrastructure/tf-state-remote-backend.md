# Terraform State Remote Backend

Terraform state file helps terraform track all resources created through it. And the state files usually contains all the meta data / information used in provisioning the resources. These can include sensitive details such as passwords, username, secrets, etc. 

Also, when teams collaborate, you need a central place where the state file can be stored so that changes to the file are updated in real time.

In AWS, S3 buckets are used for storing state files. 

## Setting up S3 bucket.

You can create a directory to handle the creation of the s3 bucket first before configuring the remote backend.

However, an important update regarding DynamoDB table used for state lock files.

For current Terraform, the clean S3 backend configuration with state locking is to use S3's native lockfile support with `use_lockfile = true`. HashiCorp documents DynamoDB-based locking as deprecated.

```
terraform {
  backend "s3" {
    bucket       = "my-terraform-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

`bucket`: S3 bucket storing the Terraform state.
`key`: path/name of the state file inside the bucket.
`region`: AWS region containing the bucket.
`encrypt = true`: encrypts the state at rest in S3.
`use_lockfile = true`: enables S3 state locking. Terraform automatically acquires the lock during operations that can modify state.

With this in place, supposing one user executes the `terraform apply` command, terraform creates a `terraform.tfstate.tflock` file. And when another user attempts `terraform apply`, Terraform sees the lock and refuses to modify the state.

Once user A finishes successfully, terraform removes the `terraform.tfstate.tflock` and user B can the acquire the lock when the command is executed.