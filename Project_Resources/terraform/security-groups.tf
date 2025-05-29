# --Grupos de Seguridad--

# 1. Grupo de Seguridad para Bastion
# Este grupo de seguridad permite todo el tráfico de entrada y salida para propósitos de demostración.
resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allow all traffic (for demo purposes)" // Permite todo el tráfico entrante.
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]                          // Permite acceso desde cualquier IP.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]                          // Permite salida hacia cualquier IP.
  }

  tags = {
    Name = "Bastion - allow all traffic"                 // Etiqueta descriptiva.
  }
}

# 2. Grupo de Seguridad para WordPress
# Este grupo de seguridad permite tráfico HTTP, HTTPS y SSH desde Bastion.
resource "aws_security_group" "wordpress" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTPS"                                // Permite tráfico HTTPS.
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"                                 // Permite tráfico HTTP.
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH desde Bastion"                    // Permite tráfico SSH desde el grupo Bastion.
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WordPress - HTTP, HTTPS, SSH desde Bastion"   // Etiqueta descriptiva.
  }
}

# 3. Grupo de Seguridad para RDS
# Este grupo de seguridad permite tráfico MySQL únicamente desde el grupo de WordPress.
resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "MySQL desde WordPress"                // Permite tráfico MySQL desde WordPress.
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.wordpress.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS - solo acceso desde WordPress"            // Etiqueta descriptiva.
  }
}

# 4. Grupo de Seguridad para el Balanceo de Carga
# Este grupo de seguridad permite tráfico HTTP y HTTPS.
resource "aws_security_group" "balanceo" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTPS"                                // Permite tráfico HTTPS.
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"                                 // Permite tráfico HTTP.
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Balanceo de carga"                           // Etiqueta descriptiva.
  }
}

# 5. Subnet Group para RDS
# Este recurso define un grupo de subredes para la base de datos RDS.
resource "aws_db_subnet_group" "RDS_subnet_grp" {
  name       = "rds-subnet-group"                        // Nombre del grupo de subredes.
  subnet_ids = [aws_subnet.subnet5.id, aws_subnet.subnet6.id] // Subredes asociadas al grupo.

  tags = {
    Name = "RDS Subnet Group"                            // Etiqueta descriptiva.
  }
}
