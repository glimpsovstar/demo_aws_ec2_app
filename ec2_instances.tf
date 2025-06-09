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
  key_name               = var.key_name
  associate_public_ip_address = true
  # Enable detailed monitoring (optional)
  monitoring = true
  
  tags = merge(
    var.tags,
    {
      Name = "${var.instance_name_prefix}"
    }
  )
}