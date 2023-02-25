resource "aws_vpc" "lab3" {
  cidr_block = var.vpc-cidr
  tags ={
    Name=var.vpc-tag-name
  }
}
data "aws_availability_zones" "available" {
  state = var.AZ-State
}

resource "aws_subnet" "pub" {
  count = length(var.subnet-cidr-pub)
  vpc_id     = aws_vpc.lab3.id
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = var.subnet-cidr-pub[count.index]

  tags = {
    Name = "public subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "priv" {
  count = length(var.subnet-cidr-prv)
  vpc_id     = aws_vpc.lab3.id
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = var.subnet-cidr-prv[count.index]

  tags = {
    Name = "private subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lab3.id

  tags = {
    Name = var.igw-name
  }
}

resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub[0].id
  tags = {
    Name = var.NAT-name
  }
}


resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.lab3.id

  route {
    cidr_block = var.GW-cidr
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "publicrouttable"
  }
}

resource "aws_route_table" "priv" {
  vpc_id = aws_vpc.lab3.id

  route {
    cidr_block = var.GW-cidr
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "privrouttable"
  }
}

resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.pub[0].id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.pub[1].id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "priv" {
  subnet_id      = aws_subnet.priv[0].id
  route_table_id = aws_route_table.priv.id
}
resource "aws_route_table_association" "priv1" {
  subnet_id      = aws_subnet.priv[1].id
  route_table_id = aws_route_table.priv.id
}
