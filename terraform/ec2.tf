resource "aws_instance" "silk_dl_windows_ec2" {
  ami           = "ami-02ed1a17d1bd5f706"
  instance_type = "t3.large"
  key_name = "datalake-sydney-kp"

  subnet_id              = aws_subnet.silk_dl_public_subnet_1.id
  associate_public_ip_address = true
  security_groups        = [aws_security_group.silk_dl_ec2_security_group.id]

  tags = {
    Name = "${var.project}-windows-ec2"
  }
}

resource "aws_instance" "silk_dl_bastion_host" {
  ami             = "ami-023eb5c021738c6d0"
  instance_type   = "t2.micro"
  key_name = "datalake-sydney-kp"

  subnet_id              = aws_subnet.silk_dl_public_subnet_1.id
  associate_public_ip_address = true
  security_groups        = [aws_security_group.silk_dl_ec2_security_group.id]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo sysctl -w net.ipv4.ip_forward=1
              sudo yum install iptables -y
              sudo iptables -t nat -A PREROUTING -p tcp --dport 5439 -j DNAT --to-destination ${aws_redshift_cluster.silk_dl_redshift_private.endpoint}
              ${aws_redshift_cluster.silk_dl_redshift_private.dns_name}
              sudo iptables -t nat -A POSTROUTING -j MASQUERADE
              EOF

  tags = {
    Name = "${var.project}-bastion-host"
  }
}
