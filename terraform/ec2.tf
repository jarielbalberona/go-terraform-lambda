resource "aws_instance" "silk_dl_windows_ec2" {
  ami           = "ami-xxxxxxxxxxxx"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.silk_dl_private_subnet.id
  associate_public_ip_address = false
  security_groups        = [aws_security_group.silk_dl_ec2_security_group.name]
  tags = {
    Name = "${var.project}-windows-ec2"
  }
}