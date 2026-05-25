output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
  description = "The name of the S3 bucket storing the Terraform state"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_state_state_lock.name
  description = "The name of the DynamoDB table for state locking"
}