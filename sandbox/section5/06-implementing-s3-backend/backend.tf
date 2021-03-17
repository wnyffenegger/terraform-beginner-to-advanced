terraform {
  backend "s3" {
    bucket = "tform-bucket"
    key    = "remotedemo.tfstate"
    region = "us-east-2"
    shared_credentials_file = "../../.aws/credentials"
    # dynamodb_table = "s3-state-lock"
  }
}