/**

To connect to RDS locally, make a connection to the RDS to the bastion host.

**/

resource "aws_iam_role" "silk_dl_glue_role" {
  name = "AWSGlueServiceRoleDefault"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "silk_dl_glue_service" {
    role = "${aws_iam_role.silk_dl_glue_role.id}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "silk_dl_s3_policy" {
  name = "${var.project}-s3-policy"
  role = "${aws_iam_role.silk_dl_glue_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_name}",
        "arn:aws:s3:::${var.s3_bucket_name}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "silk_dl_glue_service_s3" {
  name = "${var.project}-glue-service-s3"
  role = "${aws_iam_role.silk_dl_glue_role.id}"
  policy = "${aws_iam_role_policy.silk_dl_s3_policy.policy}"
}

resource "aws_glue_catalog_database" "silk_dl_catalog_database_raw" {
  name        = "aws-glue-${var.project}-raw"
  description = "AWS Glue Catalog Database for raw data"
}

resource "aws_glue_catalog_database" "silk_dl_catalog_database_curated" {
  name        = "aws-glue-${var.project}-curated"
  description = "AWS Glue Catalog Database for curated data"
}

resource "aws_glue_catalog_database" "silk_dl_catalog_database_aggregated" {
  name        = "aws-glue-${var.project}-aggregated"
  description = "AWS Glue Catalog Database for aggregated data"
}

/**
Create a connection to Amazon RDS
Create USER with password encryption md5
https://repost.aws/questions/QU5ZDUGnvnREWUT0CA-a6rSw/aws-glue-connects-to-rds-postgresql
https://stackoverflow.com/questions/76901396/failed-to-connect-amazon-rds-in-aws-glue-data-catalogs-connection
The Test Connection wont work but crawler will be successful

Step 1: Create an RDS parameter group with md5 as password encryption
Step 2: Create a user with the role

CREATE ROLE glue_readaccess;
GRANT CONNECT ON DATABASE postgres TO glue_readaccess;
GRANT USAGE ON SCHEMA public TO glue_readaccess;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO glue_readaccess;
CREATE USER gluedlpostgres WITH PASSWORD 't2101hagZO8acG9dlsFOXzDl';
GRANT glue_readaccess TO gluedlpostgres;


***/
resource "aws_glue_connection" "silk_dl_jdbc_connection" {
  connection_properties = {
    
    JDBC_CONNECTION_URL = var.silk_prod_db_jdbc_connection_url
    JDBC_ENFORCE_SSL    = "false"
    KAFKA_SSL_ENABLED    = "false"
    
    PASSWORD            = var.silk_prod_username
    USERNAME            = var.silk_prod_password
  }

  physical_connection_requirements {
    availability_zone      = aws_subnet.silk_dl_private_subnet_1.availability_zone
    security_group_id_list = [aws_security_group.silk_dl_ec2_security_group.id]
    subnet_id              = aws_subnet.silk_dl_private_subnet_1.id
  }

  name = "Silk Amazon RDS Connection"
  description = "AWS Glue Connection to Amazon RDS"
}

resource "aws_glue_connection" "silk_dl_redshift_connection" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:redshift://${aws_redshift_cluster.silk_dl_redshift_private.endpoint}/dev"
    JDBC_ENFORCE_SSL    = "false"
    KAFKA_SSL_ENABLED    = "false"
    
    USERNAME            = var.silk_dl_redshift_username
    PASSWORD            = var.silk_dl_redshift_password
  }

  physical_connection_requirements {
    availability_zone      = aws_subnet.silk_dl_private_subnet_1.availability_zone
    subnet_id              = aws_subnet.silk_dl_private_subnet_1.id
    security_group_id_list = [aws_security_group.silk_dl_redshift_sg.id]
  }

  name = "Silk Amazon Redshift Connection"
  description = "AWS Glue Connection to Amazon Redshift"
}