# Define an AWS security group resource
resource "aws_security_group" "frontend-servers" {
    name = "frontend-servers"
    description = "security group for nginx-server"  # Specify the description for the security group
    vpc_id = var.vpc_id

     tags = {
    Name        = var.tags["Name"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }
  # Define egress rules
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0" ]  # Allow all outbound traffic
      description      = ""                # No description provided
      from_port        = 0                 # Allow traffic from all ports
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "-1"              # Allow all protocols
      security_groups  = []                # No security groups specified
      self             = false             # Not referencing itself
      to_port          = 0                 # Allow traffic to all ports
    }
  ]

  # Define ingress rules
  ingress = [
    {
      cidr_blocks      = [ "0.0.0.0/0" ]  # Allow SSH traffic from anywhere
      description      = ""                # No description provided
      from_port        = 80                # Allow SSH traffic on port 80
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "tcp"             # Allow TCP protocol
      security_groups  = []                # No security groups specified
      self             = false             # Not referencing itself
      to_port          = 80                # Allow traffic to port 80
    },
    {
      cidr_blocks      = [ "0.0.0.0/0" ]  # Allow SSH traffic from anywhere
      description      = ""                # No description provided
      from_port        = 22                # Allow SSH traffic on port 22
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "tcp"             # Allow TCP protocol
      security_groups  = []                # No security groups specified
      self             = false             # Not referencing itself
      to_port          = 22                # Allow traffic to port 22
    }
  ]
}

# Define an AWS security group resource
resource "aws_security_group" "backend-servers" {
    name = "backend-servers"
    description = "security group for backend servers"  # Specify the description for the security group
    vpc_id = var.vpc_id
      tags = {
    Name        = var.tags["Name1"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]
  }

  # Define egress rules
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]  # Allow all outbound traffic
      description      = ""                # No description provided
      from_port        = 0                 # Allow traffic from all ports
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "-1"              # Allow all protocols
      security_groups  = []                # No security groups specified
      self             = false             # Not referencing itself
      to_port          = 0                 # Allow traffic to all ports
    }
  ]

  # Define ingress rules
  ingress = [
    {
      cidr_blocks      = []  # Allow SSH traffic from anywhere
      description      = ""                # No description provided
      from_port        = 22                # Allow SSH traffic on port 22
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "tcp"             # Allow TCP protocol
      security_groups  = [aws_security_group.frontend-servers.id]                # No security groups specified
      self             = true             # Referencing itself - instance in this communicating with itself. 
      to_port          = 22                # Allow traffic to port 22
    },
    {
      cidr_blocks      = []  # Allow HTTP traffic from anywhere
      description      = "open db port for webapp"                # No description provided
      from_port        = 3306                # Allow HTTP traffic on port 3306
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "tcp"             # Allow TCP protocol
      security_groups  = [aws_security_group.frontend-servers.id]               # No security groups specified
      self             = true             # Not referencing itself
      to_port          = 3306                # Allow traffic to port 3306
    },
    {
      cidr_blocks      = []  # Allow HTTP traffic from anywhere
      description      = "open memcached port for webapp"                # No description provided
      from_port        = 11211                # Allow HTTP traffic on port 3306
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "tcp"             # Allow TCP protocol
      security_groups  = []               # No security groups specified
      self             = true             # Not referencing itself
      to_port          = 11211                # Allow traffic to port 3306
    },
    {
      cidr_blocks      = []  # Allow HTTP traffic from anywhere
      description      = "open webapp port for nginx(frontend) "                # No description provided
      from_port        = 8080                # Allow HTTP traffic on port 3306
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "tcp"             # Allow TCP protocol
      security_groups  = [aws_security_group.frontend-servers.id]               # No security groups specified
      self             = true             # Not referencing itself
      to_port          = 8080                # Allow traffic to port 3306
    },
     {
      cidr_blocks      = []  # Allow HTTP traffic from anywhere
      description      = "open rabbitmq port for webapp"                # No description provided
      from_port        = 5672              # Allow HTTP traffic on port 3306
      ipv6_cidr_blocks = []                # No IPv6 CIDR blocks specified
      prefix_list_ids  = []                # No prefix list IDs specified
      protocol         = "tcp"             # Allow TCP protocol
      security_groups  = []               # No security groups specified
      self             = true             # Not referencing itself
      to_port          = 5672             # Allow traffic to port 3306
    }
  ]
}

resource "aws_security_group" "eks-sg" {
  name        = "eks-security-group"
  description = "Example security group allowing all traffic"
  vpc_id = var.vpc_id

  // Inbound rule allowing all traffic from itself
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // All protocols
    self        = true
    description = "Allow all inbound traffic from itself"
  }

  // Outbound rule allowing all traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // All protocols
    cidr_blocks = ["0.0.0.0/0"] // IPv4 and IPv6
    description = "Allow all outbound traffic to anywhere"
  }
}




