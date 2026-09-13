terraform {
  backend "s3" {
    bucket       = "nicolepaul-io-infra-tfstate-322859817636"
    key          = "nicolepaul-io-infra/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # native S3 state locking (OpenTofu >= 1.10) - no DynamoDB table needed
  }
}
