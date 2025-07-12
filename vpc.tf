variable "vpc_id" {
  description = "VPC の ID"
  type        = string
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "ssh_enable" {
  vpc_id = data.aws_vpc.main.id
  name   = "ssh-enable"
  tags = {
    Name = "ssh-enable",
  }
}

# インバウンドルール
resource "aws_vpc_security_group_ingress_rule" "ssh_enable" {

  security_group_id = aws_security_group.ssh_enable.id

  # 不正アクセス等の懸念があるため既知のIPからのみアクセスを許可する
  cidr_ipv4   = "159.28.73.109/32" # バンタンのIP
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  tags = {
    Name = "ssh-enable",
  }
}

# アウトバウンドルール
resource "aws_vpc_security_group_egress_rule" "ssh_enable_any" {
  security_group_id = aws_security_group.ssh_enable.id

  # 不正アクセス等の懸念があるため既知のIPからのみアクセスを許可する
  cidr_ipv4 = "159.28.73.109/32" # バンタンのIP
  # any
  ip_protocol = "-1"

  tags = {
    Name = "any",
  }
}

resource "aws_security_group" "rds_enable" {
  vpc_id = data.aws_vpc.main.id
  name   = "rds-enable"
  tags = {
    Name = "rds-enable",
  }
}

# インバウンドルール
resource "aws_vpc_security_group_ingress_rule" "rds_enable" {

  security_group_id = aws_security_group.rds_enable.id

  # 不正アクセス等の懸念があるため既知のIPからのみアクセスを許可する
  cidr_ipv4   = "159.28.73.109/32" # バンタンのIP
  from_port   = 5432
  ip_protocol = "tcp"
  to_port     = 5432

  tags = {
    Name = "rds-enable",
  }
}

# アウトバウンドルール
resource "aws_vpc_security_group_egress_rule" "ssh_enable_any" {
  security_group_id = aws_security_group.ssh_enable.id

  # 不正アクセス等の懸念があるため既知のIPからのみアクセスを許可する
  cidr_ipv4 = "159.28.73.109/32" # バンタンのIP
  # any
  ip_protocol = "-1"

  tags = {
    Name = "any",
  }
}
