package main

import (
	"log"
	"silk-datalake-lambda-go/internal/deputy"
	"silk-datalake-lambda-go/internal/jsonplaceholder"
	"silk-datalake-lambda-go/internal/utils"

	"github.com/aws/aws-lambda-go/lambda"

	"github.com/joho/godotenv"
)

func handler() (string, error) {
	err := godotenv.Load()

	if err != nil {
		log.Fatalf("Can't load env file. Err: %s", err)
	}

	randomString := utils.RandomString(10)
	log.Println("Start " + randomString)
	deputy.GetMyTimesheet()
	jsonplaceholder.FetchTodo()

	return "Finished λ!", nil
}

func main() {
	lambda.Start(handler)
}
