# Main Terraform file for EC2 instances in default VPC
# This configuration creates two EC2 instances in the default VPC

# Get default VPC if vpc_id is not specified
data "aws_vpc" "default" {
  default = true
  id      = var.vpc_id != null ? var.vpc_id : null
}

# Get default subnet if subnet_id is not specified
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# Get latest Amazon Linux 2 AMI if ami_id is not specified
data "aws_ami" "amazon_linux" {
  count       = var.ami_id == null ? 1 : 0
  most_recent = true
  owners      = ["amazon"]
  

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
