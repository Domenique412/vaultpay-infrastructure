terraform {
  backend "s3" {
    bucket       = "domadmin-s3-terraform-state-029637202564-us-east-1-an"
    key          = "vaultpay/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}


provider "aws" {

  region = "us-east-1"

}