# resource "aws_glue_job" "silk_db_raw_employees_job" {
#   name     = "silk-db-raw-employees-terraform-v2"
#   role_arn = aws_iam_role.silk_dl_glue_role.arn
#   glue_version = "4.0"
#   worker_type  = "G.1X"
#   number_of_workers = 10
  
#   command {
#     script_location = "s3://aws-glue-silk-datalake-system-scripts/raw/db/silk-db-raw-employees-v2.py"
#     python_version =  3
#   }
# }