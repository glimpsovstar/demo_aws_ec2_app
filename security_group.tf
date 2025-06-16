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

resource "aws_security_group" "this" {
  depends_on = [ aap_job.create_cr ]
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

# Ingress rules using the rules-only pattern - individual resources
resource "aws_security_group_rule" "ssh_ingress" {
  depends_on = [ aap_job.create_cr ]
  security_group_id = aws_security_group.this.id
  type              = "ingress"

  description = "SSH Access"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["192.168.0.0/24", "3.106.46.0/24", "0.0.0.0/0" ]

  lifecycle {
    create_before_destroy = true
  }
}

# Egress rules using the rules-only pattern - individual resources
resource "aws_security_group_rule" "all_outbound_egress" {
  depends_on = [ aap_job.create_cr ]
  security_group_id = aws_security_group.this.id
  type              = "egress"

  description = "Allow all outbound traffic"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}
