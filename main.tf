
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

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
}

resource "aws_instance" "nginx-server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name        = "var.server_name"
    Environment = "var.environment"
    Owner       = "jelsync@gmail.com"
    Team        = "DevOps"
    Project     = "TESTING"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
              EOF

  key_name               = aws_key_pair.nginx-server-ssh.key_name
  vpc_security_group_ids = [aws_security_group.nginx-server-sg.id]
}

resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "${var.server_name}-key"
  public_key = file("${var.server_name}.key.pub")
  tags = {
    Name        = "${var.server_name}-ssh"
    Environment = "${var.environment}"
    Owner       = "jelsync@gmail.com"
    Team        = "DevOps"
    Project     = "TESTING"
  }

}


resource "aws_security_group" "nginx-server-sg" {
  name        = "nginx-server-sg"
  description = "Security group allowing SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.server_name}-sg"
    Environment = "${var.environment}"
    Owner       = "jelsync@gmail.com"
    Team        = "DevOps"
    Project     = "TESTING"
  }
}


output "server_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.nginx-server.public_dns
}