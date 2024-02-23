// TEST Queries

package jsonplaceholder

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	utilsAWSS3 "silk-datalake-lambda-go/internal/utils/aws/s3"
)

func FetchTodo() string {
	// Fetch data from the API endpoint
	resp, err := http.Get("https://jsonplaceholder.typicode.com/todos/3")
	if err != nil {
		msg := fmt.Sprintf("Error fetching data: %v", err)
		log.Println(msg)
		return msg
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		msg := fmt.Sprintf("Error reading response body: %v", err)
		log.Println(msg)
		return msg
	}

	// Define a struct to hold the JSON data
	var todoData map[string]interface{}

	// Unmarshal the JSON data into the struct
	err = json.Unmarshal(body, &todoData)
	if err != nil {
		msg := fmt.Sprintf("Error unmarshalling JSON: %v", err)
		log.Println(msg)
		return msg
	}

	// Marshal the struct back into JSON bytes
	jsonBytes, err := json.Marshal(todoData)
	if err != nil {
		msg := fmt.Sprintf("Error marshalling JSON: %v", err)
		log.Println(msg)

		return msg
	}

	// Specify the bucket and object key
	bucket := "go-lambda-test-bucket"
	key := "todos/3.json"

	err = utilsAWSS3.UploadToS3(bucket, key, jsonBytes)
	if err != nil {
		fmt.Println(err)
		return err.Error()
	}

	msg := "Data uploaded to S3 successfully!"
	fmt.Println(msg)
	return msg
}
