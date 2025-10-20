terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
    region      = "us-east-2"
    access_key  = ""
    secret_key  =  ""
}

resource "aws_instance" "nginx-server" {
    ami   = "ami-0199d4b5b8b4fde0e"
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

    key_name = aws_key_pair.nginx-server-ssh.key_name
}

resource "aws_key_pair" "nginx-server-ssh" {
    key_name   = "nginx-server-key"
    public_key = file("nginx-server.key.pub")
  
}