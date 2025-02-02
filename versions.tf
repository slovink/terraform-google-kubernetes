terraform {
  required_version = ">= 1.7.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.50, < 6.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}