# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "kdg-aws-20250621-user-date-enable" {
  ami = data.aws_ami.ubuntu.id
  # AWS の無力枠を使いたいため t3.micro を使う
  instance_type = "t3.micro"

  tags = {
    Name     = "kdg-aws-20250621-user-date-enable",
    UserDate = "true"
  }

  vpc_security_group_ids = [aws_security_group.ssh_enable.id]

  user_data_replace_on_change = true
  user_data_base64            = <<EOF
IyEvdXNyL2Jpbi9lbnYgYmFzaApzZXQgLUNldXgKc2V0IC1vIHBpcGVmYWlsCgojIEdpdEh1YiDj
gavnmbvpjLLjgZfjgZ/lhazplovpjbXjgpLjg4Djgqbjg7Pjg63jg7zjg4njgZnjgosKR0lUSFVC
X1VTRVJOQU1FPSJob25haHVrdSIKd2dldCBodHRwczovL2dpdGh1Yi5jb20vJHtHSVRIVUJfVVNF
Uk5BTUV9LmtleXMKCiMgU1NIIOOBruWFrOmWi+mNteOCkumFjee9ruOBmeOCiwpta2RpciAtcCB+
Ly5zc2gvCm12ICR7R0lUSFVCX1VTRVJOQU1FfS5rZXlzIH4vLnNzaC9hdXRob3JpemVkX2tleXMK
CiMgc3NoZCDjgYzkvb/jgYjjgovjgojjgYbjgavjgZnjgovjgZ/jgoHjgavpjbXjga7jg5Hjg7zj
g5/jg4Pjgrfjg6fjg7PjgpLlpInmm7TjgZnjgosKY2htb2QgNjAwICB+Ly5zc2gvYXV0aG9yaXpl
ZF9rZXlzCg==
EOF
}
