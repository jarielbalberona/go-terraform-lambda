package s3

import (
	"bytes"
	"fmt"
	"os"

	utilsAWSSession "silk-datalake-lambda-go/internal/utils/aws/session"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/s3"
)

// UploadToS3 uploads data to an S3 bucket using the provided AWS session and bucket name
func PutToS3(objectKey string, data []byte) error {
	// Create an S3 service client
	svc := s3.New(utilsAWSSession.AwsSession)

	// Upload the data to S3
	_, err := svc.PutObject(&s3.PutObjectInput{
		Body:   bytes.NewReader(data),
		Bucket: aws.String(os.Getenv("AWS_S3_BUCKET")),
		Key:    aws.String(objectKey),
	})
	if err != nil {
		return fmt.Errorf("error uploading to S3: %v", err)
	}

	return nil
}
