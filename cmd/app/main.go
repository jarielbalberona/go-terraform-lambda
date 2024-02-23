package main

import (
	"log"
	"silk-datalake-lambda-go/internal/deputy"
	"silk-datalake-lambda-go/internal/utils"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatalf("Can't load env file. Err: %s", err)
	}

	randomString := utils.RandomString(10)
	log.Println("Hello, World! " + randomString)
	deputy.GetMyTimesheet()
	// res := jsonplaceholder.FetchTodo()
	// log.Println(res)
}
