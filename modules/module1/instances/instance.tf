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
  name = "allow_tls"
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
  cidr_ipv4         = "0.0.0.0/0"

}

resource "aws_vpc_security_group_egress_rule" "allow_tls_ipv4_out_all" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_instance" "endpoint" {
  for_each = toset(var.instance_names)

  ami           = var.ami_id
  instance_type = "t2.micro"
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
                echo '${each.key}' > /var/www/html/index.html 
                EOF
  tags = {
    Name = each.key
  }
}


resource "null_resource" "print_output" {
  for_each = aws_instance.endpoint
  provisioner "local-exec" {
    command = "echo '${each.value.public_dns}'"  
  }
}