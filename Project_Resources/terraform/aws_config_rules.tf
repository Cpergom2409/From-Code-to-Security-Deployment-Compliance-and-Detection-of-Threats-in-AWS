// --Reglas de AWS Config--

# 1. Regla para AMIs aprobadas
# Esta regla verifica que las instancias EC2 utilicen únicamente AMIs aprobadas.
resource "aws_config_config_rule" "approved_amis" {
  name = "approved-amis-by-id" // Nombre de la regla.

  source {
    owner             = "AWS"                        // AWS es el propietario de la regla.
    source_identifier = "APPROVED_AMIS_BY_ID"        // Identificador de la regla predefinida.
  }

  input_parameters = jsonencode({
    amiIds = "ami-*"                                 // Lista de AMIs aprobadas (puede ser un patrón).
  })

  depends_on = [aws_config_configuration_recorder_status.recorder_status] // Garantiza que el grabador esté habilitado antes.
}

# 2. Regla para puertos restringidos
# Esta regla verifica que no se permita tráfico SSH entrante (puerto 22).
resource "aws_config_config_rule" "restricted_ports" {
  name = "restricted-ssh" // Nombre de la regla.

  source {
    owner             = "AWS"                        // AWS es el propietario de la regla.
    source_identifier = "INCOMING_SSH_DISABLED"      // Identificador de la regla predefinida.
  }

  depends_on = [aws_config_configuration_recorder_status.recorder_status] // Garantiza que el grabador esté habilitado antes.
}

# 3. Regla para habilitar VPC Flow Logs
# Esta regla verifica que los VPC Flow Logs estén habilitados en las VPCs.
resource "aws_config_config_rule" "vpc_flow_logs" {
  name = "vpc-flow-logs-enabled" // Nombre de la regla.

  source {
    owner             = "AWS"                        // AWS es el propietario de la regla.
    source_identifier = "VPC_FLOW_LOGS_ENABLED"      // Identificador de la regla predefinida.
  }

  depends_on = [aws_config_configuration_recorder_status.recorder_status] // Garantiza que el grabador esté habilitado antes.
}

# 4. Regla para cifrado de almacenamiento en RDS
# Esta regla verifica que las bases de datos RDS tengan habilitado el cifrado de almacenamiento.
resource "aws_config_config_rule" "rds_encryption" {
  name = "rds-encryption" // Nombre de la regla.

  source {
    owner             = "AWS"                        // AWS es el propietario de la regla.
    source_identifier = "RDS_STORAGE_ENCRYPTED"      // Identificador de la regla predefinida.
  }

  depends_on = [aws_config_configuration_recorder_status.recorder_status] // Garantiza que el grabador esté habilitado antes.
}
