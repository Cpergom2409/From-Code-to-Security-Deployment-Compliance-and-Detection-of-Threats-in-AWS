# --Parámetros corregidos del módulo--

# Este bloque define un módulo de Terraform para implementar una solución de WordPress en AWS.
# El módulo utiliza configuraciones predefinidas y variables para personalizar los recursos.

module "aws_wordpress" {
  source = "./modules/latest"                            // Ruta al módulo que contiene la configuración de WordPress.

  # Requeridos por el módulo
  rds_sg_id            = aws_security_group.rds.id       // ID del grupo de seguridad asociado a la base de datos RDS.
  wordpress_sg_id      = aws_security_group.wordpress.id // ID del grupo de seguridad asociado a la instancia de WordPress.
  selected_ami         = local.selected_ami              // AMI seleccionada para las instancias EC2.
  db_subnet_group_name = aws_db_subnet_group.RDS_subnet_grp.name // Nombre del grupo de subredes para la base de datos.
  subnet3_id           = aws_subnet.subnet3.id           // ID de la subred donde se lanzarán las instancias EC2.

  # Parámetros válidos de configuración
  database_name                 = var.database_name                 // Nombre de la base de datos.
  database_user                 = var.database_user                 // Usuario para acceder a la base de datos.
  database_password             = var.database_password             // Contraseña para acceder a la base de datos.
  engine                        = var.engine                        // Motor de base de datos (por ejemplo, MySQL, PostgreSQL).
  engine_version                = var.engine_version                // Versión del motor de base de datos.
  instance_class                = var.instance_class                // Clase de instancia para la base de datos.
  backup_retention_period       = var.backup_retention_period       // Número de días para retener los respaldos de la base de datos.
  preferred_backup_window       = var.preferred_backup_window       // Ventana preferida para realizar respaldos.
  preferred_maintenance_window  = var.preferred_maintenance_window  // Ventana preferida para realizar mantenimiento.

  # Instancias EC2
  instance_type    = var.instance_type                              // Tipo de instancia EC2 (por ejemplo, t2.micro).
  root_volume_size = var.root_volume_size                           // Tamaño del volumen raíz de la instancia EC2 en GB.
  key_name         = var.key_name                                   // Nombre del par de claves para acceso SSH.
}
