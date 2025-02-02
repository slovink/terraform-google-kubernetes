terraform {
  required_version = ">= 1.7.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0, < 6.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "5.45.1"
    }
  }
}