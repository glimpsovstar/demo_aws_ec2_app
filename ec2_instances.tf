# EC2 instances in default VPC

locals {
  subnet_id      = var.subnet_id != null ? var.subnet_id : data.aws_subnets.default.ids[0]
}

# Create EC2 instances
resource "aws_instance" "this" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = local.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = module.key_pair.key_pair_name
  associate_public_ip_address = true
  # Enable detailed monitoring (optional)
  monitoring = true
  

  # User data for basic setup (optional)
#   user_data = <<-EOF
#     #!/bin/bash
#     yum update -y
#     yum install -y amazon-cloudwatch-agent
    
#     # Set hostname
#     hostnamectl set-hostname ${var.instance_name_prefix}-${count.index + 1}
    
#     # Add custom application setup steps here
#   EOF
  
  tags = merge(
    var.tags,
    {
      Name = "${var.instance_name_prefix}"
    }
  )
}


module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  key_name           = "aap-testing"
  create_private_key = true
} 