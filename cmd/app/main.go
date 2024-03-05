package main

import (
	"log"
	"silk-datalake-lambda-go/internal/deputy"
	"silk-datalake-lambda-go/internal/utils"

	"github.com/aws/aws-lambda-go/lambda"

	"github.com/joho/godotenv"
)

func handler() (string, error) {
	err := godotenv.Load()

	if err != nil {
		log.Fatalf("Can't load env file. Err: %s", err)
	}

	log.Println("Start " + utils.RandomString(10))

	errors := deputy.AllDeputyAPIRequests()
	if len(errors) > 0 {
		log.Println("Errors encountered:")
		for _, err := range errors {
			log.Println("- ", err)
		}
	} else {
		log.Println("All requests completed successfully.")
	}

	return "Finished λ!", nil
}

func main() {
	// handler()
	lambda.Start(handler)
}
