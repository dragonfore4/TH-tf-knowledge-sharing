resource "aws_instance" "bastion" {
  ami           = "ami-0279a86684f669718"
  instance_type = "t3.micro"

  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.public-subnet-1.id # ใช้ subnet ที่สร้างใน VPC

  depends_on = [aws_internet_gateway.gw]

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update 
  #             sudo apt install -y apache2
  #             sudo systemctl start apache2
  #             sudo systemctl enable apache2
  #           EOF
  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "ec2_1" {
  ami           = "ami-0279a86684f669718"
  instance_type = "t3.micro"

  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.private-subnet-1.id # ใช้ subnet ที่สร้างใน VPC

  depends_on = [aws_nat_gateway.nat]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
            EOF

  tags = {
    Name = "ec2-1"
  }
}

resource "aws_instance" "ec2_2" {
  ami           = "ami-0279a86684f669718"
  instance_type = "t3.micro"

  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.private-subnet-2.id # ใช้ subnet ที่สร้างใน VPC

  depends_on = [aws_nat_gateway.nat]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
            EOF

  tags = {
    Name = "ec2-2"
  }
}