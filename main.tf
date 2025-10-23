terraform {
  backend "s3" {
    bucket         = "terraform-jceron"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-2"
  }
}

module "nginx_server_dev" {
    source = "./nginx_server_module"

    ami_id           = "ami-0199d4b5b8b4fde0e"
    instance_type    = "t3.micro"
    server_name      = "nginx-server-dev"
    environment      = "dev"
}


module "nginx_server_qa" {
    source = "./nginx_server_module"

    ami_id           = "ami-0199d4b5b8b4fde0e"
    instance_type    = "t3.micro"
    server_name      = "nginx-server-qa"
    environment      = "qa"
}