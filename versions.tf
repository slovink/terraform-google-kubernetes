terraform {
  required_version = ">= 1.3, < 2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.10"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}