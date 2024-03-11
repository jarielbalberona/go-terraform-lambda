variable "environment" {
  type    = string
  default = "development"
}

variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "access_key" {
  type    = string
  default = "XXX"
}

variable "secret_key" {
  type    = string
  default = "GrVqvOQ66Q1KTlpiEFpnvfLe8efBTYXJTf7FG7md"
}

variable "s3_bucket" {
  type    = string
  default = "silk-datalake-terraform-state"
}

variable "project" {
  type    = string
  default = "silk-datalake"
}

variable "s3_bucket_name" {
  type    = string
  default = "aws-glue-silk-datalake-system"
}
variable "silk_prod_db_jdbc_connection_url" {
  type    = string
  default = "jdbc:postgresql://silk-db.ci5lbwwkeig4.ap-southeast-2.rds.amazonaws.com:5432/postgres"
}

variable "silk_prod_username" {
  type    = string
  default = "gluedlpostgres"
}
variable "silk_prod_password" {
  type    = string
  default = "t2101hagZO8acG9dlsFOXzDl"
}
variable "silk_dl_redshift_username" {
  type    = string
  default = "datalake"
}

variable "silk_dl_redshift_password" {
  type    = string
  default = "t2101hagZO8acG9dlsFOXzDl"
}


