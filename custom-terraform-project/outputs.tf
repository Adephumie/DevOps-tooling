# Use terraform state show name-of-resource to view the attributes of a specific resource in the Terraform 
# state file. Any of these attributes can be used to output values that you need.

output "aws_ami_id" {
  value = data.aws_ami.latest_amazon_linux_image.id
}

output "aws_instance_IP" {
  value = aws_instance.myproject-server.public_ip
}