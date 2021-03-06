provider "aws" {
 region     = "us-west-2"
}

resource "aws_security_group" "mine" {
 name = "mine"
 description = "Used in the terraform"
 
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

 ingress {
  from_port = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["${var.public_ip}"]
 }

 ingress {
  from_port = 443
  to_port     = 443 
  protocol    = "tcp"
  cidr_blocks = ["${var.public_ip}"]
 }      

 ingress {
  from_port = 25
  to_port     = 25 
  protocol    = "tcp"
  cidr_blocks = ["${var.public_ip}"]
 }
 
 egress {    
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }  
    
}

resource "aws_instance" "mine" {
 ami           = "${var.ami}"
 instance_type = "t2.micro"
 key_name="${var.private_key}"
 tags {
  pNginx = "Yes"
  pMySql = "Yes"
 }
 connection {
   user = "ubuntu"
 }
 security_groups = ["${aws_security_group.mine.name}"]
}

resource "terraform_remote_state" "mine" {
  backend = "s3"
  config {
    bucket = "myterraformremotestate"
    key = "terraform.tfstate"
    region = "us-west-2"
  }
}

