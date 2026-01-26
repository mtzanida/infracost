terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "infracost-test"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "infracost-test-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "infracost-test"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}
