# Instancia EC2 para Wazuh
resource "aws_instance" "wazuh" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"  # Recomendado para Wazuh
  subnet_id     = aws_subnet.subnet1.id  # Subnet en la VPC correcta
  key_name      = aws_key_pair.ssh_key.key_name

  root_block_device {
    volume_size = 30  
    volume_type = "gp3"
  }

  tags = {
    Name = "Wazuh-Server"
  }

  vpc_security_group_ids = [aws_security_group.wazuh.id]

  user_data = <<-EOF
              #!/bin/bash
              # Actualizar el sistema
              apt-get update
              apt-get upgrade -y
              EOF
}

# Security Group para Wazuh
resource "aws_security_group" "wazuh" {
  name        = "wazuh-sg"
  description = "Security group for Wazuh server"
  vpc_id      = aws_vpc.vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Wazuh Manager
  ingress {
    from_port   = 1514
    to_port     = 1514
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acceso desde cualquier IP
  }

  # Wazuh API
  ingress {
    from_port   = 55000
    to_port     = 55000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]  # Red interna
  }

  # Wazuh Dashboard
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Wazuh Registration Service
  ingress {
    from_port   = 1515
    to_port     = 1515
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acceso desde cualquier IP
  }

  # Egress - Permitir todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wazuh-sg"
  }
} 