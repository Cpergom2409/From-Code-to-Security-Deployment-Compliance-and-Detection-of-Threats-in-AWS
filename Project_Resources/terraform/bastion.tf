// --Instancia Bastion Host--

# Este recurso crea una instancia EC2 que actúa como Bastion Host.
# El Bastion Host se utiliza para acceder de forma segura a recursos privados dentro de la VPC.

resource "aws_instance" "bastion_host" {
  ami           = "ami-0a38b8c18f189761a" # Amazon Linux 2 (AMI predefinida).
  instance_type = "t2.micro"              # Tipo de instancia EC2 (pequeña y económica).
  subnet_id     = aws_subnet.subnet1.id   # Subred pública donde se lanzará la instancia.
  key_name      = aws_key_pair.ssh_key.key_name # Par de claves para acceso SSH.

  associate_public_ip_address = true     # Asocia una IP pública para acceso desde Internet.

  vpc_security_group_ids = [aws_security_group.bastion.id] # Grupo de seguridad asociado al Bastion Host.

  tags = {
    Name = "Bastion Host"                # Etiqueta descriptiva para identificar la instancia.
  }
}
