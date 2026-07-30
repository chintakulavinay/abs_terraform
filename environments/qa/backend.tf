terraform{
    backend "s3" {
        bucket = "terraform-state-store-vinay"
        key = "qa/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-lock"
    }
}