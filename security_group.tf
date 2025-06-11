# Security group for EC2 instances

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Security group for EC2 instances"
  vpc_id      = data.aws_vpc.default.id

  tags = merge(
    var.tags,
    {
      Name = var.security_group_name
    }
  )
}

# Create security group ingress rules
resource "aws_security_group_rule" "ingress" {
  for_each = var.security_group_ingress_rules

  security_group_id = aws_security_group.this.id
  type              = "ingress"
  
  description              = each.value.description
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  cidr_blocks             = each.value.cidr_blocks
  ipv6_cidr_blocks        = each.value.ipv6_cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  self                    = each.value.self
}

# Create security group egress rules
resource "aws_security_group_rule" "egress" {
  for_each = var.security_group_egress_rules

  security_group_id = aws_security_group.this.id
  type              = "egress"
  
  description              = each.value.description
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  cidr_blocks             = each.value.cidr_blocks
  ipv6_cidr_blocks        = each.value.ipv6_cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  self                    = each.value.self
}
