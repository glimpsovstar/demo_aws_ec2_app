# demo-aws_ec2_app_vaultagent

This Terraform configuration deploys EC2 instances with a security group in AWS, designed for applications that integrate with HashiCorp Vault Agent.

## Security Group Configuration

The security group rules are configured using `for_each` loops with map-based variables, providing better maintainability and state management compared to count-based approaches.

### Security Group Rules

You can configure ingress and egress rules using the following structure:

```hcl
security_group_ingress_rules = {
  ssh = {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  http = {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Add more rules as needed
}
```

#### Supported Rule Parameters

- `description`: Description of the security group rule
- `from_port`: Start port (0-65535)
- `to_port`: End port (0-65535)
- `protocol`: Protocol (tcp, udp, icmp, or -1 for all)
- `cidr_blocks`: List of CIDR blocks (optional)
- `ipv6_cidr_blocks`: List of IPv6 CIDR blocks (optional)
- `source_security_group_id`: Source security group ID (optional)
- `self`: Allow traffic from the same security group (optional)

### Benefits of Map-Based Configuration

1. **Better State Management**: Changes to rules don't affect other rules
2. **Readable Names**: Each rule has a meaningful key for identification
3. **Easy Maintenance**: Add, remove, or modify rules without affecting others
4. **Validation**: Built-in validation ensures port ranges are correct

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Customize the variables as needed
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`

## Migration from Count-Based Rules

If migrating from the previous count-based implementation, you'll need to:

1. Update your `terraform.tfvars` file to use the new map structure
2. Run `terraform state rm` for existing rule resources
3. Import the rules with their new identifiers, or allow Terraform to recreate them