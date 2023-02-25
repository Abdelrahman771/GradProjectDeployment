resource "aws_security_group" "PublicEC2_sg" {
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "BastionHost_From_Terraform" {
  ami           = var.ami
  instance_type = var.instance-type
  subnet_id     = var.publicSubnet_ID
  key_name      = "Abdo"

  vpc_security_group_ids = [aws_security_group.PublicEC2_sg.id]

  associate_public_ip_address = true
  tags = {
     Name = var.publicInstances-tag-name
    }
  
}