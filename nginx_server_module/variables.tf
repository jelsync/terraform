
variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  default     = "ami-0199d4b5b8b4fde0e"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t3.micro"
}

variable "server_name" {
  description = "Nombre del servidor web"
  default     = "nginx-server"
}

variable "environment" {
  description = "Ambiente de la aplicación"
  default     = "test"
}