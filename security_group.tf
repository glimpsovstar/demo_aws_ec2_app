# Security group for EC2 instances
#
# IMPORTANT: This configuration uses separate aws_security_group_rule resources
# instead of inline ingress/egress blocks to solve drift detection issues in
# Terraform Enterprise. The main security group resource explicitly defines
# empty ingress and egress blocks with ignore_changes lifecycle to prevent
# Terraform from managing rules inline while still detecting drift properly.
#
# This approach ensures:
# 1. Proper drift detection when rules are modified outside Terraform
# 2. Each rule is managed as an individual resource with unique state
# 3. Rules can be added/removed without affecting other rules
# 4. Better state management and troubleshooting capabilities

resource "aws_security_group" "this" {
  name                   = var.security_group_name
  description            = "Security group for EC2 instances"
  vpc_id                 = data.aws_vpc.default.id
  revoke_rules_on_delete = true

  # Explicitly define empty ingress and egress blocks to prevent drift
  # All rules are managed via separate aws_security_group_rule resources
  ingress = []
  egress  = []

  tags = merge(
    var.tags,
    {
      Name = var.security_group_name
    }
  )

  lifecycle {
    # Ignore changes to ingress and egress since they're managed separately
    ignore_changes = [ingress, egress]
  }
}

# Create security group ingress rules
resource "aws_security_group_rule" "ingress" {
  for_each = var.security_group_ingress_rules

  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  
  description              = each.value.description
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  cidr_blocks             = each.value.cidr_blocks
  ipv6_cidr_blocks        = each.value.ipv6_cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  self                    = each.value.self

  # Add lifecycle management to prevent recreation during minor changes
  lifecycle {
    create_before_destroy = true
  }

  # Add explicit dependencies
  depends_on = [aws_security_group.this]
}

# Create security group egress rules
resource "aws_security_group_rule" "egress" {
  for_each = var.security_group_egress_rules

  security_group_id        = aws_security_group.this.id
  type                     = "egress"
  
  description              = each.value.description
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  cidr_blocks             = each.value.cidr_blocks
  ipv6_cidr_blocks        = each.value.ipv6_cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  self                    = each.value.self

  # Add lifecycle management to prevent recreation during minor changes
  lifecycle {
    create_before_destroy = true
  }

  # Add explicit dependencies
  depends_on = [aws_security_group.this]
}
