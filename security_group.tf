# Security group for EC2 instances
#
# IMPORTANT: This configuration uses the "rules-only" approach inspired by
# terraform-aws-modules/terraform-aws-security-group. The security group
# resource is created empty, and all rules are managed via separate
# aws_security_group_rule resources for better drift detection.
#
# This approach ensures:
# 1. Proper drift detection when rules are modified outside Terraform
# 2. Each rule is managed as an individual resource with unique state
# 3. Rules can be added/removed without affecting other rules
# 4. Better state management and troubleshooting capabilities
# 5. Works well with for_each for dynamic rule creation

resource "aws_security_group" "this" {
  name                   = var.security_group_name
  description            = "Security group for EC2 instances"
  vpc_id                 = data.aws_vpc.default.id
  revoke_rules_on_delete = true

  # No inline ingress/egress rules - all managed via separate aws_security_group_rule resources
  # This is the "rules-only" pattern that provides better drift detection

  tags = merge(
    var.tags,
    {
      Name = var.security_group_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Ingress rules using the rules-only pattern
resource "aws_security_group_rule" "ingress_rules" {
  for_each = var.security_group_ingress_rules

  security_group_id = aws_security_group.this.id
  type              = "ingress"

  description              = each.value.description
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  cidr_blocks             = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks        = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
  source_security_group_id = each.value.source_security_group_id
  prefix_list_ids         = each.value.prefix_list_id != null ? [each.value.prefix_list_id] : null

  lifecycle {
    create_before_destroy = true
  }
}

# Egress rules using the rules-only pattern
resource "aws_security_group_rule" "egress_rules" {
  for_each = var.security_group_egress_rules

  security_group_id = aws_security_group.this.id
  type              = "egress"

  description              = each.value.description
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  cidr_blocks             = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks        = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
  source_security_group_id = each.value.source_security_group_id
  prefix_list_ids         = each.value.prefix_list_id != null ? [each.value.prefix_list_id] : null

  lifecycle {
    create_before_destroy = true
  }
}
