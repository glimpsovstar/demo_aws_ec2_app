# Security group for EC2 instances
#
# IMPORTANT: This configuration uses separate aws_vpc_security_group_*_rule resources
# instead of inline ingress/egress blocks or aws_security_group_rule to solve drift 
# detection issues in Terraform Enterprise. These newer resources are the current
# best practice and provide better handling of CIDR blocks, tags, and descriptions.
#
# This approach ensures:
# 1. Proper drift detection when rules are modified outside Terraform
# 2. Each rule is managed as an individual resource with unique state
# 3. Rules can be added/removed without affecting other rules
# 4. Better state management and troubleshooting capabilities
# 5. Improved handling of multiple CIDR blocks and metadata

resource "aws_security_group" "this" {
  name                   = var.security_group_name
  description            = "Security group for EC2 instances"
  vpc_id                 = data.aws_vpc.default.id
  revoke_rules_on_delete = true

  # No inline ingress/egress rules - all managed via separate resources
  # This prevents conflicts and ensures proper drift detection

  tags = merge(
    var.tags,
    {
      Name = var.security_group_name
    }
  )
}

# Create security group ingress rules using the new VPC-specific resource
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.security_group_ingress_rules

  security_group_id = aws_security_group.this.id

  description = each.value.description
  # When ip_protocol is "-1" (all protocols), from_port and to_port must be null
  from_port   = each.value.protocol == "-1" ? null : each.value.from_port
  to_port     = each.value.protocol == "-1" ? null : each.value.to_port
  ip_protocol = each.value.protocol

  # Only one of these should be specified per rule
  cidr_ipv4                    = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks[0] : null
  cidr_ipv6                    = length(coalesce(each.value.ipv6_cidr_blocks, [])) > 0 ? each.value.ipv6_cidr_blocks[0] : null
  referenced_security_group_id = each.value.source_security_group_id
  prefix_list_id               = each.value.prefix_list_id

  tags = merge(
    var.tags,
    {
      Name = "${var.security_group_name}-ingress-${each.key}"
      Rule = each.key
    }
  )

  depends_on = [aws_security_group.this]
}

# Create security group egress rules using the new VPC-specific resource
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.security_group_egress_rules

  security_group_id = aws_security_group.this.id

  description = each.value.description
  # When ip_protocol is "-1" (all protocols), from_port and to_port must be null
  from_port   = each.value.protocol == "-1" ? null : each.value.from_port
  to_port     = each.value.protocol == "-1" ? null : each.value.to_port
  ip_protocol = each.value.protocol

  # Only one of these should be specified per rule
  cidr_ipv4                    = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks[0] : null
  cidr_ipv6                    = length(coalesce(each.value.ipv6_cidr_blocks, [])) > 0 ? each.value.ipv6_cidr_blocks[0] : null
  referenced_security_group_id = each.value.source_security_group_id
  prefix_list_id               = each.value.prefix_list_id

  tags = merge(
    var.tags,
    {
      Name = "${var.security_group_name}-egress-${each.key}"
      Rule = each.key
    }
  )

  depends_on = [aws_security_group.this]
}
