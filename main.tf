resource "aws_vpc" "TerraformVpc" {
  cidr_block = var.cidrBlock
}
resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.TerraformVpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

}
resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.TerraformVpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.TerraformVpc.id
  tags = {
    Name = "My Internet Gateway"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.TerraformVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.RT.id

}

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.RT.id

}

resource "aws_security_group" "sg1" {
  #name_prefix = "web-sg-1"
  vpc_id = aws_vpc.TerraformVpc.id


  ingress {
    description = " SSH Inbound Rules"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = " TCP 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "HTTPS "
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
# resource "aws_s3_bucket" "example_bukcet" {
#   bucket = "sekhars3bucket2024"
# }
# resource "aws_instance" "webserver1" {
#   ami                    = "ami-04b70fa74e45c3917"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.subnet-1.id
#   vpc_security_group_ids = [aws_security_group.sg1.id]

#   # Read the user data script and base64 encode its content
#   user_data = base64encode(file("userdata.sh"))

#   tags = {
#     Name = "TerrServer1"
#   }
# }

# resource "aws_instance" "webserver2" {
#   ami                    = "ami-04b70fa74e45c3917"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.subnet-2.id
#   vpc_security_group_ids = [aws_security_group.sg1.id]

#   # Read the user data script and base64 encode its content
#   user_data = base64encode(file("userdata1.sh"))

#   tags = {
#     Name = "TerrServer1"
#   }
# }


# resource "aws_lb" "lb1" {
#   name               = "FirstLoadbalancer"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.sg1.id]
#   subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
#   tags = {
#     Name = "Internet-LoadBalancer"
#   }
# }
# resource "aws_lb_target_group" "tG1" {
#   name     = "TargetGroupONE"
#   vpc_id   = aws_vpc.TerraformVpc.id
#   port     = 80
#   protocol = "HTTP"
#   health_check {
#     port = "traffic-port"
#     path = "/"
#   }

# }

# resource "aws_lb_target_group_attachment" "attach1" {

#   target_group_arn = aws_lb_target_group.tG1.arn
#   target_id        = aws_instance.webserver1.id
#   port             = 80

# }
# resource "aws_lb_target_group_attachment" "attach2" {

#   target_group_arn = aws_lb_target_group.tG1.arn
#   target_id        = aws_instance.webserver2.id
#   port             = 80

# }

# resource "aws_lb_listener" "ls1" {
#   load_balancer_arn = aws_lb.lb1.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_lb_target_group.tG1.arn
#     type             = "forward"

#   }

# }

# output "loadbalancerDNSname" {
#   value = aws_lb.lb1.dns_name

# }
