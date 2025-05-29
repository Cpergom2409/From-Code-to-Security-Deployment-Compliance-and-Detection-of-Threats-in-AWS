// Variable que define el ID de la Amazon Machine Image (AMI) seleccionada para la instancia EC2.
variable "selected_ami" {}

// Variable que define el tipo de instancia EC2 (por ejemplo, t2.micro, t3.medium).
variable "instance_type" {}

// Variable que define el ID de la subred donde se lanzará la instancia EC2.
variable "subnet3_id" {}

// Variable que define el ID del grupo de seguridad asociado a la instancia de WordPress.
variable "wordpress_sg_id" {}

// Variable que define el ID del grupo de seguridad asociado a la base de datos RDS.
variable "rds_sg_id" {}

// Variable que define el nombre del par de claves para acceso SSH a la instancia EC2.
variable "key_name" {}

// Variable que define el tamaño del volumen raíz de la instancia EC2 en GB.
variable "root_volume_size" {}

# RDS

// Variable que define el motor de base de datos (por ejemplo, MySQL, PostgreSQL).
variable "engine" {}

// Variable que define la versión del motor de base de datos.
variable "engine_version" {}

// Variable que define la clase de instancia para la base de datos RDS (por ejemplo, db.t2.micro).
variable "instance_class" {}

// Variable que define el nombre de la base de datos.
variable "database_name" {}

// Variable que define el usuario para acceder a la base de datos.
variable "database_user" {}

// Variable que define la contraseña para acceder a la base de datos.
variable "database_password" {}

// Variable que define el grupo de subredes asociado a la base de datos RDS.
variable "db_subnet_group_name" {}

// Variable que define el número de días para retener los respaldos de la base de datos.
variable "backup_retention_period" {}

// Variable que define la ventana preferida para realizar respaldos de la base de datos.
variable "preferred_backup_window" {}

// Variable que define la ventana preferida para realizar el mantenimiento de la base de datos.
variable "preferred_maintenance_window" {}
