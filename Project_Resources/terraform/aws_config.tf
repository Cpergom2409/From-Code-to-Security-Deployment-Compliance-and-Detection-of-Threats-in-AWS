// --Generación de un ID aleatorio--
// Este recurso genera un ID aleatorio que se utiliza para crear un nombre único para el bucket S3.
resource "random_id" "bucket_id" {
  byte_length = 4 // Longitud del ID aleatorio en bytes.
}

// --Bucket S3 para AWS Config Logs--
// Este recurso crea un bucket S3 para almacenar los logs de AWS Config.
resource "aws_s3_bucket" "config_logs" {
  bucket        = "config-logs-${var.region}-${random_id.bucket_id.hex}" // Nombre único del bucket basado en la región y el ID aleatorio.
  force_destroy = true // Permite eliminar el bucket incluso si contiene objetos.
}

data "aws_caller_identity" "current" {}

// --Política del bucket S3--
// Este recurso define una política para el bucket S3 que permite a AWS Config acceder y escribir en él.

# Documento de política IAM para el bucket S3
data "aws_iam_policy_document" "config_logs_policy" {
  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.config_logs.arn]
  }

  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = [join("/", [aws_s3_bucket.config_logs.arn, "*"])]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# Política del bucket usando el documento IAM limpio
resource "aws_s3_bucket_policy" "config_logs_policy" {
  bucket = aws_s3_bucket.config_logs.id
  policy = data.aws_iam_policy_document.config_logs_policy.json
}


// --Rol IAM para AWS Config--
// Este recurso crea un rol IAM que AWS Config utilizará para acceder a los recursos necesarios.
resource "aws_iam_role" "config_role" {
  name = "aws-config-role" // Nombre del rol IAM.

  // Política de confianza que permite a AWS Config asumir este rol.
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "config.amazonaws.com" // AWS Config como servicio autorizado.
      },
      Action = "sts:AssumeRole" // Permite a AWS Config asumir el rol.
    }]
  })
}

// --Política en línea para el rol IAM--
// Este recurso define una política en línea que otorga permisos específicos al rol IAM.
resource "aws_iam_role_policy" "config_inline_policy" {
  name = "aws-config-inline-policy" // Nombre de la política.
  role = aws_iam_role.config_role.id // Asocia la política al rol IAM.

  // Permisos otorgados al rol IAM.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "config:Put*", // Permite operaciones de escritura en AWS Config.
          "config:Get*", // Permite operaciones de lectura en AWS Config.
          "config:Describe*", // Permite describir recursos en AWS Config.
          "s3:PutObject", // Permite escribir objetos en el bucket S3.
          "sns:Publish" // Permite publicar mensajes en SNS.
        ],
        Resource = "*" // Aplica a todos los recursos.
      },
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole" // Permite pasar roles a otros servicios.
        ],
        Resource = "*" // Aplica a todos los recursos.
      }
    ]
  })
}

// --Grabador de configuración de AWS Config--
// Este recurso configura un grabador de AWS Config que recopila información sobre los recursos de AWS.
resource "aws_config_configuration_recorder" "recorder" {
  name     = "default" // Nombre del grabador de configuración.
  role_arn = aws_iam_role.config_role.arn // ARN del rol IAM que AWS Config utilizará.

  recording_group {
    all_supported                 = true // Graba todos los tipos de recursos compatibles.
    include_global_resource_types = true // Incluye recursos globales como IAM.
  }

  depends_on = [aws_s3_bucket_policy.config_logs_policy] // Garantiza que la política del bucket esté configurada antes.
}

// --Canal de entrega para AWS Config--
// Este recurso configura un canal de entrega para enviar los datos de AWS Config al bucket S3.
resource "aws_config_delivery_channel" "channel" {
  name           = "default" // Nombre del canal de entrega.
  s3_bucket_name = aws_s3_bucket.config_logs.bucket // Nombre del bucket S3 donde se almacenarán los datos.
  depends_on     = [aws_config_configuration_recorder.recorder] // Garantiza que el grabador esté configurado antes.
}

// --Estado del grabador de configuración--
// Este recurso habilita el grabador de configuración de AWS Config.
resource "aws_config_configuration_recorder_status" "recorder_status" {
  name       = aws_config_configuration_recorder.recorder.name // Nombre del grabador de configuración.
  is_enabled = true // Habilita el grabador.
  depends_on = [aws_config_delivery_channel.channel] // Garantiza que el canal de entrega esté configurado antes.
}
