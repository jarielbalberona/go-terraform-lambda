resource "aws_redshift_subnet_group" "silk_dl_redshift_subnet_group_private" {
  name       = "silk-dl-redshift-subnet-group-private"
  subnet_ids = [aws_subnet.silk_dl_private_subnet_1.id, aws_subnet.silk_dl_private_subnet_2.id, aws_subnet.silk_dl_private_subnet_3.id]

  tags = {
    Name = "Silk Datenbank Redshift Subnet Group Private"
  }
}

resource "aws_redshift_cluster" "silk_dl_redshift_private" {
  cluster_identifier           = "${var.project}-redshift-cluster-private"
  database_name                = "dev"
  master_username              = "datalake"
  master_password              = "t2101hagZO8acG9dlsFOXzDl"
  node_type          = "ra3.xlplus"
  cluster_type       = "single-node"
  publicly_accessible = false
  skip_final_snapshot = true
  
  vpc_security_group_ids     = [aws_security_group.silk_dl_redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.silk_dl_redshift_subnet_group_private.name


  tags = {
    Name = "SilkDatalakeRedshiftPrivate"
  }
}