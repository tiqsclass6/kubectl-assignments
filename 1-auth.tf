terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use latest version if possible
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }

  }

  backend "s3" {
    bucket  = "your-s3-bucket-name"               # Name of the S3 bucket
    key     = "dateortime.tfstate"                # The name of the state file in the bucket
    region  = "us-east-1"                         # Use a variable for the region
    encrypt = true                                # Enable server-side encryption (optional but recommended)
  }
}


provider "aws" {
  region  = var.region
  profile = "default"
}
