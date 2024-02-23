package deputy

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	utilsAWSS3 "silk-datalake-lambda-go/internal/utils/aws/s3"
	"silk-datalake-lambda-go/internal/utils/http/endpoint"
)

func GetMyTimesheet() string {
	body, err := DeputyAPIRequest("my_timesheets")

	if err != nil {
		msg := fmt.Sprintf("Error reading response body: %v", err)
		log.Println(msg)
		return msg
	}

	// Define a struct to hold the JSON data

	var deputyData []map[string]interface{}

	// Unmarshal the JSON data into the struct
	err = json.Unmarshal(body, &deputyData)
	if err != nil {
		msg := fmt.Sprintf("Error unmarshalling JSON: %v", err)
		log.Println(msg)
		return msg
	}

	// Marshal the struct back into JSON bytes
	jsonBytes, err := json.Marshal(deputyData)
	if err != nil {
		msg := fmt.Sprintf("Error marshalling JSON: %v", err)
		log.Println(msg)

		return msg
	}

	key := "timesheet/2024/02/21/1.json"
	SaveToS3(jsonBytes, key)

	return "Yeeep"
}

func DeputyAPIRequest(path string) ([]byte, error) {
	req, err := http.NewRequest("GET", endpoint.GetEndpoint(path), nil)
	if err != nil {
		return nil, err
	}

	// Set the "Authorization" header with the Bearer token
	token := os.Getenv("DEPUTY_BEARER_TOKEN")
	req.Header.Set("Authorization", "Bearer "+token)

	client := http.DefaultClient
	resp, err := client.Do(req)

	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)

	return body, err
}

func SaveToS3(jsonBytes []byte, key string) error {
	bucket := os.Getenv("AWS_S3_BUCKET")

	err := utilsAWSS3.UploadToS3(bucket, key, jsonBytes)
	if err != nil {
		log.Println(err)
		return err
	}

	msg := "Data uploaded to S3 successfully!"
	log.Println(msg)

	return nil
}
