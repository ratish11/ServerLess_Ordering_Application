#!/bin/bash 

yum update -y                           

yum install -y httpd                    

systemctl start httpd                   

systemctl enable httpd                   

echo "SERVICE A" > /var/www/html/index.html