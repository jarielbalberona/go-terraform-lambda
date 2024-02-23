variable "environment" {
  type    = string
  default = "development"
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "access_key" {
  type    = string
  default = "AKIAXCSMC4SDLDFUJAVV"
}

variable "secret_key" {
  type    = string
  default = "GrVqvOQ66Q1KTlpiEFpnvfLe8efBTYXJTf7FG7md"
}

variable "s3_bucket" {
  type    = string
  default = "silk-datalake-terraform-state"
}

variable "project" {
  type    = string
  default = "silk-datalake"
}


