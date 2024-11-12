terraform {
  backend "s3" {
    bucket         = "manoloboampongweek10"
    key            = "week10/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "state-log"
  }
}
