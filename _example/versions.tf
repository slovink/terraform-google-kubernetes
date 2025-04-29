terraform {
  required_version = ">= 1.9.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0, < 5.11.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
