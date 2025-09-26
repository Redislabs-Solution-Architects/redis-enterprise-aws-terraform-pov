resource "aws_security_group" "redis_re" {
  name        = "${local.effective_prefix}-sg"
  description = "Redis Enterprise single-node PoV"
  vpc_id      = var.vpc_id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
    description = "SSH"
  }

  # Admin UI
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
    description = "Redis Enterprise UI (HTTPS)"
  }

  # Mgmt API
  ingress {
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
    description = "Mgmt API (HTTPS)"
  }

  # Redis DB ephemeral/test range
  ingress {
    from_port   = 12000
    to_port     = 19999
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
    description = "Redis DB ports (PoV/testing)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Egress to Internet"
  }

  # Name tag already provided by local.common_tags (set to local.effective_prefix)
  tags = local.common_tags
}