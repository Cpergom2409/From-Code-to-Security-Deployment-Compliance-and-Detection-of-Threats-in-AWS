# Configuración de la instancia EC2 para Nessus Essentials
# Este archivo define los recursos necesarios para desplegar una instancia EC2
# que ejecutará Nessus Essentials en AWS.

# Grupo de seguridad para la instancia de Nessus
resource "aws_security_group" "nessus" {
  name        = "{YOUR-SG-NAME}"  # Nombre del grupo de seguridad
  description = "Security group for Nessus Essentials"  # Descripción del grupo
  vpc_id      = aws_vpc.main.id  # VPC donde se creará el grupo

  # Regla de entrada para SSH (puerto 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["{YOUR-ALLOWED-CIDR}"]  # Permite acceso SSH desde IPs específicas
    description = "SSH access"
  }

  # Regla de entrada para Nessus (puerto 8834)
  ingress {
    from_port   = 8834
    to_port     = 8834
    protocol    = "tcp"
    cidr_blocks = ["{YOUR-ALLOWED-CIDR}"]  # Permite acceso a Nessus desde IPs específicas
    description = "Nessus web interface"
  }

  # Regla de salida para todo el tráfico
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]  # Permite todo el tráfico saliente
    description = "Allow all outbound traffic"
  }

  # Etiquetas para identificar el recurso
  tags = {
    Name = "{YOUR-SG-NAME}"
  }
}

# Instancia EC2 para Nessus
resource "aws_instance" "nessus" {
  ami           = "{YOUR-AMI-ID}"  # AMI de Ubuntu 22.04 LTS
  instance_type = "{YOUR-INSTANCE-TYPE}"  # Tipo de instancia recomendado para Nessus
  key_name      = aws_key_pair.ssh_key.key_name  # Clave SSH para acceso

  # Configuración del volumen raíz
  root_block_device {
    volume_size = {YOUR-VOLUME-SIZE}  # Tamaño del volumen en GB
    volume_type = "gp3"  # Tipo de volumen (gp3 es más rápido y económico que gp2)
    encrypted   = true  # Encriptación del volumen
    tags = {
      Name = "{YOUR-VOLUME-NAME}"
    }
  }

  # Configuración de la red
  subnet_id                   = aws_subnet.public[0].id  # Subnet pública
  vpc_security_group_ids      = [aws_security_group.nessus.id]  # Grupo de seguridad
  associate_public_ip_address = true  # Asigna IP pública

  # Script de inicialización que se ejecuta al crear la instancia
  user_data = <<-EOF
              #!/bin/bash
              # Actualiza el sistema
              apt-get update
              apt-get upgrade -y
              
              # Instala dependencias básicas
              apt-get install -y python3-pip
              
              # Configura el hostname
              hostnamectl set-hostname {YOUR-NESSUS-HOSTNAME}
              
              # Reinicia el servicio de red
              systemctl restart systemd-networkd
              EOF

  # Etiquetas para identificar la instancia
  tags = {
    Name = "{YOUR-INSTANCE-NAME}"
  }
}

# Outputs para mostrar información importante
output "nessus_public_ip" {
  value       = aws_instance.nessus.public_ip  # IP pública de la instancia
  description = "Public IP address of the Nessus instance"
}

output "nessus_private_key_path" {
  value       = local_file.private_key.filename  # Ruta al archivo de clave privada
  description = "Path to the private key file"
} 