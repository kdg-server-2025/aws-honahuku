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
X1VTRVJOQU1FPSJob25haHVrdSIKaWYgISB3Z2V0IC0tdHJpZXM9NTAgLS13YWl0cmV0cnk9MTAg
LS1jb25uZWN0LXRpbWVvdXQ9MTAgLU8gYXV0aG9yaXplZF9rZXlzIGh0dHBzOi8vZ2l0aHViLmNv
bS8ke0dJVEhVQl9VU0VSTkFNRX0ua2V5cwp0aGVuCiAgIyBTU0gg44Gu5YWs6ZaL6Y2144KS6YWN
572u44GZ44KLCiAgbWtkaXIgLXAgfi8uc3NoLwogIG12IGF1dGhvcml6ZWRfa2V5cyB+Ly5zc2gv
CgogICMgc3NoZCDjgYzkvb/jgYjjgovjgojjgYbjgavjgZnjgovjgZ/jgoHjgavpjbXjga7jg5Hj
g7zjg5/jg4Pjgrfjg6fjg7PjgpLlpInmm7TjgZnjgosKICBjaG1vZCA2MDAgIH4vLnNzaC9hdXRo
b3JpemVkX2tleXMKICBleGl0IDAKZWxzZQogIGV4aXQgMQpmaQo=
EOF
}
