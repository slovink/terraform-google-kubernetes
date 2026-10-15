terraform {
  required_version = ">= 1.12.0, < 1.16.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 8.0.0, < 9.0.0"
    }
  }
}

