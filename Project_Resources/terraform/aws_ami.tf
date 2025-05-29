# --Parámetros AMI--

# 1. AMI Amazon Linux 2
# Este bloque obtiene la AMI más reciente de Amazon Linux 2.
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["{YOUR-AMI-PATTERN}"]              // Patrón para identificar AMIs
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# 2. AMI Ubuntu 20.04 LTS (Focal)
# Este bloque obtiene la AMI más reciente de Ubuntu 20.04 LTS.
data "aws_ami" "ubuntu" {
  most_recent = true                                      // Selecciona la AMI más reciente disponible.

  filter {
    name   = "name"                                       // Filtra por el nombre de la AMI.
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] // Patrón para identificar AMIs de Ubuntu 20.04.
  }

  filter {
    name   = "virtualization-type"                       // Filtra por el tipo de virtualización.
    values = ["hvm"]                                     // Solo AMIs con virtualización HVM.
  }

  owners = ["099720109477"]                              // Limita la búsqueda a AMIs propiedad de Canonical.
}

# 3. Selección condicional de AMI
# Esta variable local define cuál AMI usar dependiendo de la variable IsUbuntu.
locals {
  selected_ami = var.IsUbuntu ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux_2.id
  // Si IsUbuntu es verdadero, selecciona la AMI de Ubuntu; de lo contrario, selecciona la de Amazon Linux 2.
}

