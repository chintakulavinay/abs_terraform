terraform{
    backend "s3" {
        bucket = "terraform-state-store-vinay"
        key = "dev/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-lock"
    }
}