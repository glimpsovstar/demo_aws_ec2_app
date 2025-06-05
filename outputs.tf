# Output variables for the EC2 instances

output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.this[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of the created EC2 instances"
  value       = aws_instance.this[*].public_ip
}

output "instance_private_ips" {
  description = "Private IP addresses of the created EC2 instances"
  value       = aws_instance.this[*].private_ip
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.this.id
}

output "vpc_id" {
  description = "ID of the VPC where resources were created"
  value       = data.aws_vpc.default.id
}

output "subnet_id" {
  description = "ID of the subnet where instances were created"
  value       = local.subnet_id
}


output "public_fqdn" {
  description = "Public FQDN of the AAP instance"
  value       = aws_instance.this[*].public_dns
}