
# ---------------------------------------------------------
# SECURITY GROUP RDS
# ---------------------------------------------------------

resource "aws_security_group" "wordpress_rds_sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_instance_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  name = "terraform_rds"
  tags = {
    "Name" = "Wordpress RDS Security group"
  }
}


# ---------------------------------------------------------
# SECURITY GROUP LOAD BALANCE
# ---------------------------------------------------------

resource "aws_security_group" "wordpress_lb_sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  name = "terraform_load_balance"
  tags = { "Name" = "Wordpress Load Balancer Security group"
  }
}


# ---------------------------------------------------------
# SECURITY GROUP INSTANCE
# ---------------------------------------------------------

resource "aws_security_group" "wordpress_instance_sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_lb_sg.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  name = "terraform_instance"
  tags = {
    "Name" = "Wordpress Instance Security group"
  }
}
