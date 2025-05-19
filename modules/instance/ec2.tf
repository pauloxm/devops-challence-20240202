data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]

  }

  owners = ["099720109477"]
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key-pair" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.private_key.private_key_pem}' > '${var.private_key_path}/${var.private_key}' 
      chmod 400 '${var.private_key_path}/${var.private_key}'
    EOT
  }

}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key-pair.key_name
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  associate_public_ip_address = true

  tags = {
    Name        = var.name
    Environment = var.env
    Provisioner = "Terraform"
    Repo        = var.repo
  }
}

resource "null_resource" "connect_ansible_hosts" {
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = tls_private_key.private_key.private_key_pem
    host        = aws_instance.instance.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "echo 'SSH disponível para conexão remota e execução de script Ansible...'"
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.instance.public_ip}, --private-key ${var.private_key_path}/${var.private_key} playbook.yml --ssh-common-args='-o StrictHostKeyChecking=no'"
  }
}