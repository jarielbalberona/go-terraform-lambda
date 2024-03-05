package deputy

import (
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

var errMsg = "Error reading response body:"

// Error returns the error message.
func (e *CustomError) Error() string {
	return e.Message
}

func DeputyAPIS3Request(path string, key string) error {
	body, err := DeputyAPIRequest(path)

	if err != nil {
		msg := fmt.Sprintf("%s %v", errMsg, err)
		err := &CustomError{
			Message: msg,
		}

		return err
	}

	err = utilsAWSS3.PutToS3("raw", key, body)

	if err != nil {
		msg := fmt.Sprintf("%s %v", errMsg, err)
		err := &CustomError{
			Message: msg,
		}

		return err
	}

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

func AllDeputyAPIRequests() []error {
	var errors []error

	// Collect errors from each DeputyAPIS3Request function call
	if err := DeputyAPIS3Request("get_operational_department_units", "operational_department_units.json"); err != nil {
		errors = append(errors, err)
	}
	if err := DeputyAPIS3Request("get_company_workplaces", "company_workplaces.json"); err != nil {
		errors = append(errors, err)
	}
	if err := DeputyAPIS3Request("get_company_locations", "company_locations.json"); err != nil {
		errors = append(errors, err)
	}
	if err := DeputyAPIS3Request("get_all_employee_details", "all_employee_details.json"); err != nil {
		errors = append(errors, err)
	}
	if err := DeputyAPIS3Request("pay_rates_awards_library", "pay_rates_awards_library.json"); err != nil {
		errors = append(errors, err)
	}

	return errors
}
