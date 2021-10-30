resource "aws_security_group" this {
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "-1"
    from_port   = 9200
    to_port     = 9300
    this = true
    cidr_blocks = var.webaccess_cidr_blocks
    security_groups = var.webaccess_security_groups
  }

  ingress {
    protocol    = "-1"
    from_port   = 9300
    to_port     = 9400
    this = true
  }
  tags = var.tags
}
