# -- Variables --

# Variable que define el nombre de la base de datos.
variable "database_name" {
  description = "Nombre de la base de datos"
  default     = "{YOUR-DATABASE-NAME}"
}

# Variable que define la contraseña para acceder a la base de datos.
variable "database_password" {
  description = "Database password"
  type        = string
  default     = "{YOUR-DATABASE-PASSWORD}"
}

# Variable que define el usuario para acceder a la base de datos.
variable "database_user" {
  description = "Usuario de la base de datos"
  default     = "{YOUR-DATABASE-USER}"
}

# Variable que define la región donde se desplegarán los recursos en AWS.
variable "region" {
  description = "Región que vamos a utilizar"
  default     = "us-east-1"
}

# Variable que define la clave de acceso pública para la cuenta de AWS.
variable "access_key" {
  description = "AWS Access Key"
  type        = string
  default     = "{YOUR-AWS-ACCESS-KEY}"
}

# Variable que define la clave de acceso privada para la cuenta de AWS.
variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  default     = "{YOUR-AWS-SECRET-KEY}"
}

# Variable booleana que indica si la instancia es Ubuntu o Amazon Linux.
variable "IsUbuntu" {
  description = "Indicamos que la instancia es Ubuntu, de lo contrario será Amazon Linux"
  type        = bool
  default     = true
}

# Variables que definen las zonas de disponibilidad.
variable "AZ1" {
  description = "Zona 1"
  default     = "us-east-1a"
}

variable "AZ2" {
  description = "Zona 2"
  default     = "us-east-1b"
}

# Variable que define el rango de direcciones IP para la VPC.
variable "VPC_cidr" {
  description = "Red VPC"
  default     = "30.0.0.0/16"
}

# Variables que definen los rangos de direcciones IP para las subredes.
variable "subnet1_cidr" {
  description = "Subred Bastion-1"
  default     = "30.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "Subred Bastion-2"
  default     = "30.0.2.0/24"
}

variable "subnet3_cidr" {
  description = "Subred Wordpress-1"
  default     = "30.0.3.0/24"
}

variable "subnet4_cidr" {
  description = "Subred Wordpress-2"
  default     = "30.0.4.0/24"
}

variable "subnet5_cidr" {
  description = "Subred RDS-1"
  default     = "30.0.5.0/24"
}

variable "subnet6_cidr" {
  description = "Subred RDS-2"
  default     = "30.0.6.0/24"
}

# Variables que definen las rutas a las claves SSH.
variable "PUBLIC_KEY_PATH" {
  description = "Path to public key"
  type        = string
  default     = "./{YOUR-KEY-NAME}.pub"
}

variable "PRIV_KEY_PATH" {
  description = "Path to private key"
  type        = string
  default     = "./{YOUR-KEY-NAME}"
}

variable "KEY_PUTTY" {
  description = "Path to Putty key"
  type        = string
  default     = "./{YOUR-KEY-NAME}.ppk"
}

# Variable que define el nombre del par de claves SSH.
variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "{YOUR-KEY-NAME}"
}

# Variable que define el tipo de instancia para WordPress.
variable "instance_type" {
  description = "Tipo de instancia para Wordpress"
  default     = "t2.micro"
}

# Variable que define la clase de instancia para la base de datos RDS.
variable "instance_class" {
  description = "Clase de instancia RDS"
  default     = "db.t3.micro"
}

# Variable que define el motor de la base de datos.
variable "engine" {
  description = "Motor de la base de datos"
  default     = "mysql"
}

# Variable que define la versión del motor de la base de datos.
variable "engine_version" {
  description = "Versión del motor de la base de datos"
  default     = "8.0"
}

# Variable que define el período de retención de backups en días.
variable "backup_retention_period" {
  description = "Período de retención de backups (en días)"
  default     = 7
}

# Variable que define la ventana preferida para realizar backups.
variable "preferred_backup_window" {
  description = "Ventana preferida para backups"
  default     = "07:00-09:00"
}

# Variable que define la ventana preferida para realizar mantenimiento.
variable "preferred_maintenance_window" {
  description = "Ventana de mantenimiento preferida"
  default     = "Mon:05:00-Mon:07:00"
}

# Variable que define el tamaño del almacenamiento para la instancia de WordPress en GB.
variable "root_volume_size" {
  description = "Tamaño de almacenamiento (GB) para la instancia de Wordpress"
  default     = 20
}
