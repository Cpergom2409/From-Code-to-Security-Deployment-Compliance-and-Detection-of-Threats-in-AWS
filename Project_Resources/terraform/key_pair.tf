# Generar un par de claves SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Crear el par de claves en AWS usando la clave pública existente
resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
  public_key = file(var.PUBLIC_KEY_PATH)
}

# Guardar la clave privada en un archivo local
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.key_name}"
  file_permission = "0600"
}

# Output para mostrar la ubicación de la clave privada
output "private_key_path" {
  value       = var.PRIV_KEY_PATH
  description = "Ruta al archivo de la clave privada"
  sensitive   = true
} 