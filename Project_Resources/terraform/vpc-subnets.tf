# --VPC & Subredes--

# 1. Creamos la VPC (Virtual Private Cloud)
# Este recurso define una red privada virtual (VPC) con soporte para DNS y hostnames internos.
resource "aws_vpc" "vpc" {
  cidr_block           = "{YOUR-VPC-CIDR}"                  // Rango de direcciones IPv4 para la VPC.
  enable_dns_support   = true                           // Habilita soporte para DNS interno.
  enable_dns_hostnames = true                           // Habilita nombres de host internos.
  instance_tenancy     = "default"                      // Tenencia predeterminada para las instancias.

  tags = {
    Name = "{YOUR-VPC-NAME}"                                        // Etiqueta descriptiva para la VPC.
  }
}

# 2. Subred pública: Bastion-1
# Subred pública en la zona de disponibilidad 1 para el acceso al bastion.
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "{YOUR-SUBNET1-CIDR}"               // Rango de direcciones IPv4 para la subred.
  availability_zone       = var.AZ1                     // Zona de disponibilidad 1.
  map_public_ip_on_launch = true                        // Asigna IP pública automáticamente.

  tags = {
    Name = "{YOUR-SUBNET1-NAME}"                           // Etiqueta descriptiva para la subred.
  }
}

# 3. Subred pública: Bastion-2
# Subred pública en la zona de disponibilidad 2 para el acceso al bastion.
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "{YOUR-SUBNET2-CIDR}"               // Rango de direcciones IPv4 para la subred.
  availability_zone       = var.AZ2                     // Zona de disponibilidad 2.
  map_public_ip_on_launch = true                        // Asigna IP pública automáticamente.

  tags = {
    Name = "{YOUR-SUBNET2-NAME}"                           // Etiqueta descriptiva para la subred.
  }
}

# 4. Subred privada: WordPress-1
# Subred privada en la zona de disponibilidad 1 para el servidor de WordPress.
resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "{YOUR-SUBNET3-CIDR}"                    // Rango de direcciones IPv4 para la subred.
  availability_zone = var.AZ1                          // Zona de disponibilidad 1.
  map_public_ip_on_launch = false                      // No asigna IP pública automáticamente.

  tags = {
    Name = "{YOUR-SUBNET3-NAME}"                        // Etiqueta descriptiva para la subred.
  }
}

# 5. Subred privada: WordPress-2
# Subred privada en la zona de disponibilidad 2 para el servidor de WordPress.
resource "aws_subnet" "subnet4" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "{YOUR-SUBNET4-CIDR}"                    // Rango de direcciones IPv4 para la subred.
  availability_zone = var.AZ2                          // Zona de disponibilidad 2.
  map_public_ip_on_launch = false                      // No asigna IP pública automáticamente.

  tags = {
    Name = "{YOUR-SUBNET4-NAME}"                        // Etiqueta descriptiva para la subred.
  }
}

# 6. Subred privada: RDS-1
# Subred privada en la zona de disponibilidad 1 para la base de datos RDS.
resource "aws_subnet" "subnet5" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "{YOUR-SUBNET5-CIDR}"                    // Rango de direcciones IPv4 para la subred.
  availability_zone = var.AZ1                          // Zona de disponibilidad 1.
  map_public_ip_on_launch = false                      // No asigna IP pública automáticamente.

  tags = {
    Name = "{YOUR-SUBNET5-NAME}"                              // Etiqueta descriptiva para la subred.
  }
}

# 7. Subred privada: RDS-2
# Subred privada en la zona de disponibilidad 2 para la base de datos RDS.
resource "aws_subnet" "subnet6" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "{YOUR-SUBNET6-CIDR}"                    // Rango de direcciones IPv4 para la subred.
  availability_zone = var.AZ2                          // Zona de disponibilidad 2.
  map_public_ip_on_launch = false                      // No asigna IP pública automáticamente.

  tags = {
    Name = "{YOUR-SUBNET6-NAME}"                              // Etiqueta descriptiva para la subred.
  }
}

# 8. Internet Gateway
# Este recurso crea un gateway de Internet para permitir acceso público a las subredes públicas.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet Gateway - Public & Private VPC"   // Etiqueta descriptiva para el gateway.
  }
}

# 9. Tabla de rutas pública
# Define una tabla de rutas para las subredes públicas que permite acceso a Internet.
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"                           // Permite tráfico hacia cualquier destino.
    gateway_id = aws_internet_gateway.igw.id           // Asocia la tabla de rutas al Internet Gateway.
  }

  tags = {
    Name = "Enrutamiento para Internet Gateway"        // Etiqueta descriptiva para la tabla de rutas.
  }
}

# 10. Asociaciones de rutas públicas
# Asocia la tabla de rutas pública con las subredes públicas.
resource "aws_route_table_association" "rt-association1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "rt-association2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public-rt.id
}

# --------------------- NAT 1 --------------------------------

# 11. Elastic IP para NAT Gateway 1
# Este recurso asigna una IP elástica para el NAT Gateway 1.
resource "aws_eip" "Nat-Gateway-1" {
  depends_on = [
    aws_route_table_association.rt-association1,
    aws_route_table_association.rt-association2
  ]
  vpc = true
}

# 11.5 NAT Gateway 1
# Este recurso crea un NAT Gateway en la subred pública Bastion-1.
resource "aws_nat_gateway" "NAT_GATEWAY_1" {
  depends_on    = [aws_eip.Nat-Gateway-1]
  allocation_id = aws_eip.Nat-Gateway-1.id
  subnet_id     = aws_subnet.subnet1.id
  tags = {
    Name = "Nat-Gateway_1"
  }
}

# 12. Tabla de rutas para NAT Gateway 1
# Define una tabla de rutas para el NAT Gateway 1.
resource "aws_route_table" "NAT_Gateway_RT_1" {
  depends_on = [aws_nat_gateway.NAT_GATEWAY_1]
  vpc_id     = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY_1.id
  }
  tags = {
    Name = "Route Table for NAT Gateway-1"
  }
}

# 13. Asociación a subnet privada Wordpress-1
# Asocia la tabla de rutas del NAT Gateway 1 con la subred privada Wordpress-1.
resource "aws_route_table_association" "Nat_Gateway_RT_Association_1" {
  depends_on    = [aws_route_table.NAT_Gateway_RT_1]
  subnet_id     = aws_subnet.subnet3.id
  route_table_id = aws_route_table.NAT_Gateway_RT_1.id
}

# --------------------- NAT 2 --------------------------------

# 14. Elastic IP para NAT Gateway 2
# Este recurso asigna una IP elástica para el NAT Gateway 2.
resource "aws_eip" "Nat-Gateway-2" {
  depends_on = [
    aws_route_table_association.rt-association1,
    aws_route_table_association.rt-association2
  ]
  vpc = true
}

# 14.5 NAT Gateway 2
# Este recurso crea un NAT Gateway en la subred pública Bastion-2.
resource "aws_nat_gateway" "NAT_GATEWAY_2" {
  depends_on    = [aws_eip.Nat-Gateway-2]
  allocation_id = aws_eip.Nat-Gateway-2.id
  subnet_id     = aws_subnet.subnet2.id
  tags = {
    Name = "Nat-Gateway_2"
  }
}

# 15. Tabla de rutas para NAT Gateway 2
# Define una tabla de rutas para el NAT Gateway 2.
resource "aws_route_table" "NAT_Gateway_RT_2" {
  depends_on = [aws_nat_gateway.NAT_GATEWAY_2]
  vpc_id     = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY_2.id
  }
  tags = {
    Name = "Route Table for NAT Gateway-2"
  }
}

# 16. Asociación a subnet privada Wordpress-2
# Asocia la tabla de rutas del NAT Gateway 2 con la subred privada Wordpress-2.
resource "aws_route_table_association" "Nat_Gateway_RT_Association_2" {
  depends_on    = [aws_route_table.NAT_Gateway_RT_2]
  subnet_id     = aws_subnet.subnet4.id
  route_table_id = aws_route_table.NAT_Gateway_RT_2.id
}
