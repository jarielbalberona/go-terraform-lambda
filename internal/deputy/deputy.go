package deputy

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	utilsAWSS3 "silk-datalake-lambda-go/internal/utils/aws/s3"
	"silk-datalake-lambda-go/internal/utils/http/endpoint"
)

type CustomError struct {
	Message string
}

// Error returns the error message.
func (e *CustomError) Error() string {
	return e.Message
}

func GetMyTimesheet() error {
	body, err := DeputyAPIRequest("my_timesheets")

	if err != nil {
		msg := fmt.Sprintf("Error reading response body: %v", err)
		err := &CustomError{
			Message: msg,
		}

		return err
	}

	// Define a struct to hold the JSON data

	var deputyData []map[string]interface{}

	// Unmarshal the JSON data into the struct
	err = json.Unmarshal(body, &deputyData)
	if err != nil {
		msg := fmt.Sprintf("Error unmarshalling JSON: %v", err)
		err := &CustomError{
			Message: msg,
		}
		return err
	}

	// Marshal the struct back into JSON bytes
	jsonBytes, err := json.Marshal(deputyData)
	if err != nil {
		msg := fmt.Sprintf("Error marshalling JSON: %v", err)
		err := &CustomError{
			Message: msg,
		}

		return err
	}

	key := "timesheet/2024/02/21/1.json"
	utilsAWSS3.PutToS3(key, jsonBytes)

	return nil
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
