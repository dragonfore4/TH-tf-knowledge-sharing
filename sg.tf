resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "bastion_sg"
  vpc_id      = aws_vpc.demo-vpc.id # ระบุ VPC ที่จะใช้

  tags = {
    "Name" = "bastion_sg"
  }

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_bastion" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic_bastion" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.demo-vpc.id

  tags = {
    Name = "ec2_sg"
  }
}

# Ingress Rule for EC2 Instance (Allow SSH)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ec2" {
  security_group_id            = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.bastion_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  description                  = "Allow SSH from bastion"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic_ec2" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}
