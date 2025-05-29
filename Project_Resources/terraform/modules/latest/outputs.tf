// --Outputs del módulo--

# 1. IP privada del servidor WordPress
# Este output expone la dirección IP privada de la instancia EC2 que aloja el servidor WordPress.
output "wordpress_private_ip" {
  value = aws_instance.wordpress_instance.private_ip // Obtiene la IP privada de la instancia EC2.
}

# 2. Endpoint de la base de datos RDS
# Este output expone el endpoint de la base de datos RDS utilizada por WordPress.
output "rds_endpoint" {
  value = aws_db_instance.wordpress_db.endpoint // Obtiene el endpoint de la base de datos RDS.
}
