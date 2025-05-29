# VPC principal
resource "aws_vpc" "main" {
  cidr_block           = "{YOUR-VPC-CIDR}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "{YOUR-VPC-NAME}"
  }
}

# Subredes públicas
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "{YOUR-SUBNET-CIDR-${count.index + 1}}"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "{YOUR-SUBNET-NAME-${count.index + 1}}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "{YOUR-IGW-NAME}"
  }
}

# Tabla de rutas principal
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "{YOUR-RT-NAME}"
  }
}

# Asociación de tabla de rutas con subred pública
resource "aws_route_table_association" "public" {
  count          = 1
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.main.id
}

# Data source para obtener las zonas de disponibilidad
data "aws_availability_zones" "available" {
  state = "available"
} 