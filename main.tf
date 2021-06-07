resource "aws_instance" "app" {
    count = var.provision_app == "true" ? var.instance_count : 0
    ami           = var.ami_id
    instance_type = var.instance_type
    root_block_device {
        volume_size = var.app_volume["volume_size"]
        volume_type = var.app_volume["volume_type"] 
        # device_name = var.app_volume["device_name"] 
    }
    user_data_base64 = var.userdatab64
    key_name = var.ssh_key_name
    vpc_security_group_ids = [ aws_security_group.app_sg.id ]
    tags = {
        Name = "AppServer-${count.index+1}"
    }

    provisioner "file" {
        source = "${path.root}/files/webapp.go"
        destination = "/tmp/webapp.go"
        connection {
            type     = "ssh"
            user     = "ubuntu"
            private_key = file("${path.root}/${var.ssh_key_name}.pem")
            host     = "${self.public_ip}"
        }
    }
}


resource "aws_security_group" "app_sg" {
  name        = "Application_SG"
  description = "Allow Traffic to Application Server"
  vpc_id      = var.vpc_id == "default" ? data.aws_vpc.default.id : var.vpc_id

#   ingress {
#     description      = "HTTP traffic"
#     from_port        = 8484
#     to_port          = 8484
#     protocol         = "tcp"
#     cidr_blocks      = [data.aws_vpc.default.cidr_block]
#     #security_groups = [var.web_sg_id]
#     # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }
  tags = {
    Name = "AppServerSG"
  }
}


resource "aws_security_group_rule" "rule1" {
  type              = "ingress"
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  security_group_id = "${aws_security_group.app_sg.id}"
  description      = "SSH traffic"
}

resource "aws_security_group_rule" "rule2" {
  type              = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = "${aws_security_group.app_sg.id}"
    description      = "Allow All Egress Traffic"
  }

data "aws_vpc" "default" {
  default = true
}