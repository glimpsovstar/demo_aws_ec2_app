# Output variables for the EC2 instances

output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.this.id
}

output "instance_public_ips" {
  description = "Public IP addresses of the created EC2 instances"
  value       = aws_instance.this.public_ip
}

output "instance_private_ips" {
  description = "Private IP addresses of the created EC2 instances"
  value       = aws_instance.this.private_ip
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
  value       = aws_instance.this.public_dns
}

output "security_group_ingress_rules" {
  description = "Map of ingress security group rules with their IDs and configurations"
  value = {
    ssh = {
      id                       = aws_security_group_rule.ssh_ingress.id
      description              = aws_security_group_rule.ssh_ingress.description
      from_port               = aws_security_group_rule.ssh_ingress.from_port
      to_port                 = aws_security_group_rule.ssh_ingress.to_port
      protocol                = aws_security_group_rule.ssh_ingress.protocol
      cidr_blocks             = aws_security_group_rule.ssh_ingress.cidr_blocks
      ipv6_cidr_blocks        = aws_security_group_rule.ssh_ingress.ipv6_cidr_blocks
      source_security_group_id = aws_security_group_rule.ssh_ingress.source_security_group_id
      prefix_list_ids         = aws_security_group_rule.ssh_ingress.prefix_list_ids
      type                    = aws_security_group_rule.ssh_ingress.type
    }
  }
}

output "security_group_egress_rules" {
  description = "Map of egress security group rules with their IDs and configurations"
  value = {
    all_outbound = {
      id                       = aws_security_group_rule.all_outbound_egress.id
      description              = aws_security_group_rule.all_outbound_egress.description
      from_port               = aws_security_group_rule.all_outbound_egress.from_port
      to_port                 = aws_security_group_rule.all_outbound_egress.to_port
      protocol                = aws_security_group_rule.all_outbound_egress.protocol
      cidr_blocks             = aws_security_group_rule.all_outbound_egress.cidr_blocks
      ipv6_cidr_blocks        = aws_security_group_rule.all_outbound_egress.ipv6_cidr_blocks
      source_security_group_id = aws_security_group_rule.all_outbound_egress.source_security_group_id
      prefix_list_ids         = aws_security_group_rule.all_outbound_egress.prefix_list_ids
      type                    = aws_security_group_rule.all_outbound_egress.type
    }
  }
}

output "security_group_rules_summary" {
  description = "Summary of all security group rules"
  value = {
    security_group_id  = aws_security_group.this.id
    ingress_count      = 1
    egress_count       = 1
    ingress_rule_names = ["ssh"]
    egress_rule_names  = ["all_outbound"]
  }
}

# output "key_pair_name" {
#   description = "Name of the key pair"
#   value       = module.key_pair.key_pair_name
# }

# output "private_key_pem" {
#   description = "Private key in PEM format"
#   value       = module.key_pair.private_key_pem
#   sensitive   = true
# }
