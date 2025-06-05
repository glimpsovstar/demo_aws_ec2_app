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
  count = length(var.security_group_ingress_rules)

  security_group_id = aws_security_group.this.id
  type              = "ingress"
  
  description       = var.security_group_ingress_rules[count.index].description
  from_port         = var.security_group_ingress_rules[count.index].from_port
  to_port           = var.security_group_ingress_rules[count.index].to_port
  protocol          = var.security_group_ingress_rules[count.index].protocol
  cidr_blocks       = var.security_group_ingress_rules[count.index].cidr_blocks
}

# Create security group egress rules
resource "aws_security_group_rule" "egress" {
  count = length(var.security_group_egress_rules)

  security_group_id = aws_security_group.this.id
  type              = "egress"
  
  description       = var.security_group_egress_rules[count.index].description
  from_port         = var.security_group_egress_rules[count.index].from_port
  to_port           = var.security_group_egress_rules[count.index].to_port
  protocol          = var.security_group_egress_rules[count.index].protocol
  cidr_blocks       = var.security_group_egress_rules[count.index].cidr_blocks
}
