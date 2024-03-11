import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

# Create a GlueContext
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# Get job parameters
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

# Create a Glue job
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Define source connection properties
datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "aws_glue_silk_datalake_raw", table_name = "employeesX", transformation_ctx = "datasource0")

# Connect to the RDS PostgreSQL database
datasource1 = glueContext.create_dynamic_frame.from_options(connection_type = "postgresql", connection_options = {"url": "jdbc:postgresql://silk-db.ci5lbwwkeig4.ap-southeast-2.rds.amazonaws.com:5432/postgres", "dbtable": "employees", "user": "gluedlpostgres", "password": "t2101hagZO8acG9dlsFOXzDl"}, transformation_ctx = "datasource1")

# Apply any transformations if needed
# Example transformation: convert dynamic frame to data frame
df = datasource1.toDF()

# Write data to S3
output_path = "s3://aws-glue-silk-datalake-system/raw/db/employees/manual/"
datasink = glueContext.write_dynamic_frame.from_options(frame = datasource1, connection_type = "s3", connection_options = {"path": output_path}, format = "parquet", format_options = {"compression": "gzip"}, transformation_ctx = "datasink")

# Commit the job
job.commit()
