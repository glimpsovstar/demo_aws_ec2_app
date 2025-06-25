# Security group for EC2 instances
#
# IMPORTANT: This configuration uses the "rules-only" approach with the newer
# VPC security group rule resources (aws_vpc_security_group_ingress_rule and 
# aws_vpc_security_group_egress_rule). The security group resource is created 
# empty, and all rules are managed via separate VPC security group rule resources.
#
# This approach ensures:
# 1. Proper drift detection when rules are modified outside Terraform
# 2. Each rule is managed as an individual resource with unique state
# 3. Rules can be added/removed without affecting other rules
# 4. Better state management and troubleshooting capabilities
# 5. Uses the newer AWS VPC security group rule resources for enhanced functionality

resource "aws_security_group" "this" {
  depends_on = [ aap_job.create_cr ]
  name                   = var.security_group_name
  description            = "Security group for EC2 instances"
  vpc_id                 = data.aws_vpc.default.id
  revoke_rules_on_delete = true

  # No inline ingress/egress rules - all managed via separate VPC security group rule resources
  # This is the "rules-only" pattern that provides better drift detection

  tags = merge(
    var.tags,
    {
      Name = var.security_group_name
    }
  )

  lifecycle {
    #create_before_destroy = true
  }
}

# Ingress rules using the newer VPC security group rule resources
resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
  depends_on        = [aap_job.create_cr]
  security_group_id = aws_security_group.this.id

  description = "SSH Access"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "192.168.0.0/24"

  tags = {
    Name = "SSH Access - 192.168.0.0/24"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress_aap1" {
  depends_on        = [aap_job.create_cr]
  security_group_id = aws_security_group.this.id

  description = "SSH Access - AAP Range 1"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "3.106.46.0/24"

  tags = {
    Name = "SSH Access - 3.106.46.0/24"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress_aap2" {
  depends_on        = [aap_job.create_cr]
  security_group_id = aws_security_group.this.id

  description = "SSH Access - AAP Range 2"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "54.252.254.0/24"

  tags = {
    Name = "SSH Access - 54.252.254.0/24"
  }
}

# aws_vpc_security_group_ingress_rule for port 80 (HTTP) access
resource "aws_vpc_security_group_ingress_rule" "http_ingress" {
  depends_on        = [aap_job.create_cr]
  security_group_id = aws_security_group.this.id
  description = "HTTP Access"
  to_port     = 8081
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  tags = {
    Name = "HTTP Access - 0.0.0.0/0"
  }
}

# Egress rules using the newer VPC security group rule resources
resource "aws_vpc_security_group_egress_rule" "all_outbound_egress" {
  depends_on        = [aap_job.create_cr]
  security_group_id = aws_security_group.this.id

  description = "Allow all outbound traffic"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "All Outbound Traffic"
  }
}
