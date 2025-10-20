
variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "server_name" {
  description = "Nombre del servidor web"
  type        = string
}

variable "environment" {
  description = "Ambiente de la aplicación"
  type        = string
}
