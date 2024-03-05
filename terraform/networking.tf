resource "aws_vpc" "silk_dl_vpc" {
  cidr_block = "10.20.0.0/16"
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "silk_dl_public_subnet_1" {
  vpc_id            = aws_vpc.silk_dl_vpc.id
  cidr_block        = "10.20.0.0/20"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "${var.project}-public-subnet-1"
  }
}
resource "aws_subnet" "silk_dl_public_subnet_2" {
  vpc_id            = aws_vpc.silk_dl_vpc.id
  cidr_block        = "10.20.16.0/20"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "${var.project}-public-subnet-2"
  }
}

resource "aws_subnet" "silk_dl_private_subnet_1" {
  vpc_id            = aws_vpc.silk_dl_vpc.id
  cidr_block        = "10.20.32.0/20"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "${var.project}-private-subnet-1"
  }
}
resource "aws_subnet" "silk_dl_private_subnet_2" {
  vpc_id            = aws_vpc.silk_dl_vpc.id
  cidr_block        = "10.20.64.0/20"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "${var.project}-private-subnet-2"
  }
}

resource "aws_internet_gateway" "silk_dl_igw" {
  vpc_id = aws_vpc.silk_dl_vpc.id
  tags = {
    Name = "${var.project}-internet-gateway"
  }
}

resource "aws_route_table" "silk_dl_public_route_table" {
  vpc_id = aws_vpc.silk_dl_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.silk_dl_igw.id
  }

  tags = {
    Name = "${var.project}-public-route-table"
  }
}

resource "aws_route_table" "silk_dl_private_route_table" {
  vpc_id = aws_vpc.silk_dl_vpc.id
  tags = {
    Name = "${var.project}-private-route-table"
  }
}

resource "aws_route" "silk_dl_s3_route" {
  route_table_id            = aws_route_table.silk_dl_private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.silk_dl_nat_gateway.id
}

resource "aws_route_table_association" "silk_dl_public_subnet_association_1" {
  subnet_id      = aws_subnet.silk_dl_public_subnet_1.id
  route_table_id = aws_route_table.silk_dl_public_route_table.id
}

resource "aws_route_table_association" "silk_dl_private_subnet_association_1" {
  subnet_id      = aws_subnet.silk_dl_private_subnet_1.id
  route_table_id = aws_route_table.silk_dl_private_route_table.id
}

resource "aws_route_table_association" "silk_dl_public_subnet_association_2" {
  subnet_id      = aws_subnet.silk_dl_public_subnet_2.id
  route_table_id = aws_route_table.silk_dl_public_route_table.id
}

resource "aws_route_table_association" "silk_dl_private_subnet_association_2" {
  subnet_id      = aws_subnet.silk_dl_private_subnet_2.id
  route_table_id = aws_route_table.silk_dl_private_route_table.id
}

resource "aws_nat_gateway" "silk_dl_nat_gateway" {
  allocation_id = aws_eip.silk_dl_eip.id
  subnet_id     = aws_subnet.silk_dl_public_subnet_2.id
  tags = {
    Name = "${var.project}-nat-gateway"
  }
}

resource "aws_eip" "silk_dl_eip" {
  tags = {
    Name = "${var.project}-eip"
  }
}

resource "aws_security_group" "silk_dl_ec2_security_group" {
  name        = "${var.project}-ec2-security-group"
  description = "Allow inbound traffic from VPC"
  vpc_id      = aws_vpc.silk_dl_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/20"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "silk_dl_s3_endpoint" {
  vpc_id = aws_vpc.silk_dl_vpc.id
  service_name = "com.amazonaws.ap-southeast-2.s3"
  route_table_ids = [aws_route_table.silk_dl_private_route_table.id] # Assuming you have a private route table
  tags = {
    Name = "silk-dl-s3-endpoint"
  }
}