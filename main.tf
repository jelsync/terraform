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
  ami           = "ami-0199d4b5b8b4fde0e"
  instance_type = "t3.micro"
  tags = {
    Name = "NginxServer"
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
  key_name   = "nginx-server-key"
  public_key = file("nginx-server.key.pub")

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
    Name        = "nginx-server-sg"
    Environment = "nginx-server"
    Owner       = "jelsync@gmail.com"
    Team        = "DevOps"
    Project     = "TESTING"
  }
}
