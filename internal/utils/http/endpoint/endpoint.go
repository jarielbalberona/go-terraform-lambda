package endpoint

import (
	"encoding/json"
	"fmt"
	"os"
)

type Endpoints map[string]string

type APIEndpoint struct {
	BaseURL   string    `json:"base_url"`
	Endpoints Endpoints `json:"endpoints"`
}

func EndpointsFromJSON(filename string) (*APIEndpoint, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	var endpoint APIEndpoint
	err = json.Unmarshal(data, &endpoint)
	if err != nil {
		return nil, err
	}
	return &endpoint, nil
}

func GetEndpoint(path string) string {
	deputyConfig, err := EndpointsFromJSON("config/endpoints/deputy.json")

	if err != nil {
		fmt.Println("Error loading endpoint:", err)
		return "test"
	}

	APIEndpointPath := deputyConfig.BaseURL + deputyConfig.Endpoints[path]
	return APIEndpointPath
}
