// TEST Queries

package jsonplaceholder

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	utilsAWSS3 "silk-datalake-lambda-go/internal/utils/aws/s3"
)

func FetchTodo() string {
	// Fetch data from the API endpoint
	resp, err := http.Get("https://jsonplaceholder.typicode.com/todos/3")
	if err != nil {
		msg := fmt.Sprintf("Error fetching data: %v", err)
		return msg
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		msg := fmt.Sprintf("Error reading response body: %v", err)
		return msg
	}

	// Define a struct to hold the JSON data
	var todoData map[string]interface{}

	// Unmarshal the JSON data into the struct
	err = json.Unmarshal(body, &todoData)
	if err != nil {
		msg := fmt.Sprintf("Error unmarshalling JSON: %v", err)
		return msg
	}

	// Marshal the struct back into JSON bytes
	jsonBytes, err := json.Marshal(todoData)
	if err != nil {
		msg := fmt.Sprintf("Error marshalling JSON: %v", err)

		return msg
	}

	key := "todos/test.json"

	err = utilsAWSS3.PutToS3("raw", key, jsonBytes)
	if err != nil {
		fmt.Println(err)
		return err.Error()
	}

	msg := "Data uploaded to S3 successfully!"
	return msg
}
