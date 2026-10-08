locals {
  # reachable only from your IP
  admin_ports = {
    ssh        = 22
    jenkins    = 8080
    k3s_api    = 6443
    grafana    = 32000
    prometheus = 32090
  }

  # public web app
  app_ports = {
    http         = 80
    https        = 443
    app_nodeport = 30080
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${var.name}-key"
  public_key = var.public_key
}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Nexvion DevOps server"
  vpc_id      = var.vpc_id

  tags = { Name = "${var.name}-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "admin" {
  for_each = local.admin_ports

  security_group_id = aws_security_group.this.id
  description       = "admin ${each.key}"
  cidr_ipv4         = var.admin_cidr
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "app" {
  for_each = local.app_ports

  security_group_id = aws_security_group.this.id
  description       = "app ${each.key}"
  cidr_ipv4         = var.app_cidr
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  metadata_options {
    http_tokens   = "required" # IMDSv2 only
    http_endpoint = "enabled"
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = "${var.name}-server" }
}
