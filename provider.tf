terraform {
  required_providers {
    ocm = {
      version = ">= 0.1"
      source  = "localhost/openshift-online/ocm"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
  }
}

provider "ocm" {
  token = local.token
  url   = local.url
}

provider "aws" {
  access_key = local.access_key
  secret_key = local.secret_key
  region     = local.region
}
