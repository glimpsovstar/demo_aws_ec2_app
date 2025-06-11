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
    for rule_name, rule in aws_vpc_security_group_ingress_rule.this : rule_name => {
      id                           = rule.id
      security_group_rule_id       = rule.security_group_rule_id
      description                  = rule.description
      from_port                    = rule.from_port
      to_port                      = rule.to_port
      ip_protocol                  = rule.ip_protocol
      cidr_ipv4                    = rule.cidr_ipv4
      cidr_ipv6                    = rule.cidr_ipv6
      referenced_security_group_id = rule.referenced_security_group_id
      prefix_list_id               = rule.prefix_list_id
      tags                         = rule.tags
    }
  }
}

output "security_group_egress_rules" {
  description = "Map of egress security group rules with their IDs and configurations"
  value = {
    for rule_name, rule in aws_vpc_security_group_egress_rule.this : rule_name => {
      id                           = rule.id
      security_group_rule_id       = rule.security_group_rule_id
      description                  = rule.description
      from_port                    = rule.from_port
      to_port                      = rule.to_port
      ip_protocol                  = rule.ip_protocol
      cidr_ipv4                    = rule.cidr_ipv4
      cidr_ipv6                    = rule.cidr_ipv6
      referenced_security_group_id = rule.referenced_security_group_id
      prefix_list_id               = rule.prefix_list_id
      tags                         = rule.tags
    }
  }
}

output "security_group_rules_summary" {
  description = "Summary of all security group rules"
  value = {
    security_group_id  = aws_security_group.this.id
    ingress_count      = length(aws_vpc_security_group_ingress_rule.this)
    egress_count       = length(aws_vpc_security_group_egress_rule.this)
    ingress_rule_names = keys(aws_vpc_security_group_ingress_rule.this)
    egress_rule_names  = keys(aws_vpc_security_group_egress_rule.this)
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
