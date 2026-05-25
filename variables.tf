variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
  # this has my account ID at the end
  default = "devops100-terraform-state-605893375337"
}

variable "dynamodb_table_name" {
  default = "terraform-state-lock"
}