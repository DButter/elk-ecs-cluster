resource "aws_security_group" this {
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 9200
    to_port     = 9300
    self = true
    cidr_blocks = var.webaccess_cidr_blocks
    security_groups = concat(var.webaccess_security_groups, [aws_security_group.allow_http_and_https.id])
  }

  ingress {
    protocol    = "tcp"
    from_port   = 9300
    to_port     = 9400
    self = true
  }
  tags = var.tags
}

resource "aws_security_group" allow_http_and_https {
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    self = true
    cidr_blocks = var.webaccess_cidr_blocks
    security_groups = var.webaccess_security_groups
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    self = true
    cidr_blocks = var.webaccess_cidr_blocks
    security_groups = var.webaccess_security_groups
  }
  tags = var.tags
}
