
   
# To create sg

resource "aws_security_group" "security" {
  name        = var.name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["103.110.170.85/32"]
  } 

 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sgname
  }
}

# To create keypair

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChqAZWCFQuVRIZdCN5NwgTZCRVpqBIY5YQRRzRZqB5997IkDocFT0G7mDwh8wWcsqUp74KS280LMlHKZ10rPw/kkAxjnwldqSinD4K+C8rquP23c/h/VUbA6T+siJs9i81qkgWnY6ipFSVMUHe+TrTvTH/yKo4V/C7Ae5uAbEck9sq/XU3BtqOLotbpbqsXCzfe+l2hZ76Pw5Snj8+A4XB0rsmZcv2NkgBixwMsvvPQitoFhNO2wT7dA83XcD3+Z9RjbfSyWTkMJDetQH+he6TvY6OvSU+OpitDYSm/CgxHL3c2ebLxAOZa3v/Fc5H+JBFfmSFaBYnc8DZk7PlIBLbSYjeUL7JER8pHAmEsRnO4iLNXi3WOJxb+2yojTviQXScLD6ekhIFyKwPzPs4u4ll61k48THmbKSeEkQ/4tqfipDBVdpf1VmNBlnBZ7ZHloKXAdN68pjwRhxpJxUQ0vsD1dTTOFTasl0nRbMKQ/pJmP1JMJrm7zc5oMESeTFh5JE= Bala@LAPTOP-E3S8V9GE"
}

# To create instance

resource "aws_instance" "instance" {
    count = 3
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.key.id
    vpc_security_group_ids =  ["${aws_security_group.security.id}"]
    user_data = <<EOF

    #!/bin/bash
    yum update -y
    yum install httpd -y 
    systemctl enable httpd
    systemctl start httpd
    mkdir -p  /var/www/html/
    echo "this is Balakonda" >/var/www/html/index.html

    EOF 


    tags = {
        Name = var.ec2-name
    }
}
