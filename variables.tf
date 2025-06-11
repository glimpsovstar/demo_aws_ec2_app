variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-2"  # Change this to your preferred region
}

# Variables for the EC2 instances in default VPC

variable "instance_name_prefix" {
  description = "Prefix for the name tag of EC2 instances"
  type        = string
  default     = "app-server"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use for the instances"
  type        = string
  # This is a placeholder - you should use a data source or provide a specific AMI ID
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID to launch the instances in (if not provided, a subnet from the default VPC will be used)"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID to create resources in (if not provided, the default VPC will be used)"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the instances"
  type        = string
  default     = null
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
  default     = "ec2-instances-sg"
}

variable "security_group_ingress_rules" {
  description = "List of ingress rules for the security group"
  type        = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default     = [
    {
      description = "SSH from anywhere"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "security_group_egress_rules" {
  description = "List of egress rules for the security group"
  type        = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default     = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "demo-app"
    Terraform   = "true"
  }
}
