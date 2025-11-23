
terraform {
  backend "s3" {
    bucket         = "terraform-state-file-olabucket1"       # Replace with your bucket name
    key            = "state.tfstate" # Path within the bucket
    region         = "eu-west-2"                # Replace with your bucket's region
  }
}


terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}
