import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

# Get job arguments
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

# Initialize Spark context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# Create a Glue job
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read data from PostgreSQL
PostgreSQL_node = glueContext.create_dynamic_frame.from_options(
    connection_type="postgresql",
    connection_options={
        "url": "jdbc:postgresql://silk-db.ci5lbwwkeig4.ap-southeast-2.rds.amazonaws.com:5432/postgres",
        "user": "gluedlpostgres",  # Replace with your username
        "password": "t2101hagZO8acG9dlsFOXzDl",  # Replace with your password
        "dbtable": "employees",  # Specify the table name to extract data from
    },
    transformation_ctx="PostgreSQL_node"
)

# Write data to Amazon S3
AmazonS3_node = glueContext.getSink(
    path="s3://aws-glue-silk-datalake-system/raw/db/employees/manual/",  # Specify the S3 path to write data to
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],  # Specify partition keys if needed
    enableUpdateCatalog=True,
    transformation_ctx="AmazonS3_node"
)

# Set catalog information and output format
AmazonS3_node.setCatalogInfo(catalogDatabase="aws-glue-silk-datalake-raw", catalogTableName="employeesX")
AmazonS3_node.setFormat("glueparquet", compression="gzip")

# Write data to S3
AmazonS3_node.writeFrame(PostgreSQL_node)

# Commit the job
job.commit()
