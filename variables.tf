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
  description = "Map of ingress rules for the security group"
  type = map(object({
    description              = string
    from_port               = number
    to_port                 = number
    protocol                = string
    cidr_blocks             = optional(list(string))
    ipv6_cidr_blocks        = optional(list(string))
    source_security_group_id = optional(string)
    self                    = optional(bool)
  }))
  default = {
    ssh = {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  validation {
    condition = alltrue([
      for rule in values(var.security_group_ingress_rules) : 
      rule.from_port >= 0 && rule.from_port <= 65535 && 
      rule.to_port >= 0 && rule.to_port <= 65535 &&
      rule.from_port <= rule.to_port
    ])
    error_message = "Port numbers must be between 0 and 65535, and from_port must be less than or equal to to_port."
  }
}

variable "security_group_egress_rules" {
  description = "Map of egress rules for the security group"
  type = map(object({
    description              = string
    from_port               = number
    to_port                 = number
    protocol                = string
    cidr_blocks             = optional(list(string))
    ipv6_cidr_blocks        = optional(list(string))
    source_security_group_id = optional(string)
    self                    = optional(bool)
  }))
  default = {
    all_outbound = {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  validation {
    condition = alltrue([
      for rule in values(var.security_group_egress_rules) : 
      rule.from_port >= 0 && rule.from_port <= 65535 && 
      rule.to_port >= 0 && rule.to_port <= 65535 &&
      rule.from_port <= rule.to_port
    ])
    error_message = "Port numbers must be between 0 and 65535, and from_port must be less than or equal to to_port."
  }
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
