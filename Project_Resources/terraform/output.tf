// --Outputs--

# 1. IP privada del servidor WordPress
# Este output expone la dirección IP privada del servidor WordPress.
output "wordpress_private_ip" {
  description = "IP privada del servidor Wordpress" // Descripción del output.
  value       = module.aws_wordpress.wordpress_private_ip // Obtiene la IP privada desde el módulo aws_wordpress.
}

# 2. Endpoint de la base de datos RDS
# Este output expone el endpoint de la base de datos RDS.
output "rds_endpoint" {
  description = "Endpoint de la base de datos RDS" // Descripción del output.
  value       = module.aws_wordpress.rds_endpoint // Obtiene el endpoint desde el módulo aws_wordpress.
}