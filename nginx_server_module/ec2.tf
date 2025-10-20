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