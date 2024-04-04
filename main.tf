terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# resource "tls_private_key" "private_keypair" {
#     algorithm       = "RSA"
#     rsa_bits        = 4096
# }

# resource "aws_key_pair" "generated_key" {
#     key_name        = "test-keypair"
#     public_key      = tls_private_key.private_keypair.public_key_openssh
#     provisioner "local-exec" {
#         command = "echo '${tls_private_key.private_keypair.private_key_pem}' > ./'${key_name}'.pem"
#     }
# }
# data "local_file" "user_data" {
#   filename = "user_data.sh"
# }
# module "sg_group" {
#   source = "./"
# }
resource "aws_security_group" "allow_tls" {
  name   = "allow_tls"
  # vpc_id = aws_vpc.main.id
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_in_http" {
  security_group_id = aws_security_group.allow_tls.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_in_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "155.186.179.245/32"
  
}

resource "aws_vpc_security_group_egress_rule" "allow_tls_ipv4_out_all" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_instance" "endpoint-a" {
  ami             = "ami-019f9b3318b7155c5"
  instance_type   = "t2.micro"
  # security_groups = ["${aws_security_group.allow_tls.id}"]
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  # key_name        = aws_key_pair.generated_key.key_name
  # user_data_base64  = base64encode(data.local_file.user_data.filename.rendered)
  user_data = <<-EOF
                #!/bin/bash 
                yum update -y                           
                yum install -y httpd                    
                systemctl start httpd                   
                systemctl enable httpd                   
                echo 'SERVICE A' > /var/www/html/index.html 
                EOF
  tags = {
    Name = "Endpoint A"
  }
}

# output "private_key_pair" {
#   value       = tls_private_key.private_keypair.private_key_pem
#   sensitive   = true
#   description = "Key pair for the generated instance "
#   depends_on  = []
# }
