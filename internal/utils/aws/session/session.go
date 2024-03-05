package session

import (
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
)

var AwsSession *session.Session

func init() {
	region := os.Getenv("AWS_REGION")
	if region == "" {
		region = "ap-southeast-2"
	}
	AwsSession = session.Must(session.NewSession(&aws.Config{
		Region: aws.String(region),
	}))
}
