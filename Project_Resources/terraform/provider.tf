# --Definimos el proveedor (AWS)--

# Este bloque configura el proveedor de Terraform para AWS.
# Utiliza variables para definir las credenciales y la región, lo que permite flexibilidad y seguridad.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.76.1"  # Versión específica que sabemos que funciona
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Cambia esto según tu región preferida
}
