// Este recurso define una instancia de AWS EC2 para alojar un servidor de WordPress.
// Utiliza variables para configurar sus atributos, lo que permite flexibilidad y reutilización.
resource "aws_instance" "wordpress_instance" {
  ami                    = var.selected_ami                // ID de la Amazon Machine Image (AMI) seleccionada.
  instance_type          = var.instance_type               // Tipo de instancia EC2 (por ejemplo, t2.micro, t3.medium).
  subnet_id              = var.subnet3_id                  // ID de la subred donde se lanzará la instancia.
  vpc_security_group_ids = [var.wordpress_sg_id]           // Grupo(s) de seguridad asociado(s) a la instancia.
  key_name               = var.key_name                    // Nombre del par de claves para acceso SSH.

  // Configuración del dispositivo de almacenamiento raíz de la instancia.
  root_block_device {
    volume_size = var.root_volume_size                     // Tamaño del volumen raíz en GB.
  }

  // Etiquetas para identificar la instancia en la consola de AWS.
  tags = {
    Name = "WordPress Server"                              // Nombre descriptivo para la instancia.
  }
}

// Este recurso define una instancia de base de datos AWS RDS para la aplicación de WordPress.
// Utiliza variables para configurar sus atributos, asegurando flexibilidad y mantenibilidad.
resource "aws_db_instance" "wordpress_db" {
  allocated_storage       = 20                             // Tamaño del almacenamiento de la base de datos en GB.
  engine                  = var.engine                     // Motor de base de datos (por ejemplo, MySQL, PostgreSQL).
  engine_version          = var.engine_version             // Versión del motor de base de datos.
  instance_class          = var.instance_class             // Clase de instancia para la base de datos (por ejemplo, db.t2.micro).
  name                    = var.database_name              // Nombre de la base de datos.
  username                = var.database_user              // Usuario para acceder a la base de datos.
  password                = var.database_password          // Contraseña para acceder a la base de datos.
  db_subnet_group_name    = var.db_subnet_group_name       // Grupo de subredes asociado a la base de datos.
  vpc_security_group_ids  = [var.rds_sg_id]                // Grupo(s) de seguridad asociado(s) a la base de datos.
  skip_final_snapshot     = true                           // Omite la creación de un snapshot final al eliminar la base de datos.
  publicly_accessible     = false                          // Asegura que la base de datos no sea accesible públicamente.

  backup_retention_period = var.backup_retention_period    // Número de días para retener los respaldos de la base de datos.
}
