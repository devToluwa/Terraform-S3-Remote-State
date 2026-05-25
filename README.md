# Terraform S3 Remote State Backend

**Production-grade remote state management for Terraform using AWS S3 and DynamoDB.**

## What This Does

1. Stores Terraform state remotely in S3 instead of your laptop
2. Enables team collaboration - everyone works from the same state
3. Implements state locking to prevent concurrent modifications
4. Adds versioning so you can recover from corrupted state
5. Encrypts state files to protect sensitive data

## The Problem

Without remote state:
- State file lives on your laptop - if it's lost, all infrastructure tracking is gone
- Teams can't collaborate - everyone has different state files
- No locking - two people can run terraform apply simultaneously and corrupt state
- No backup - one bad command and everything is gone
- Secrets in state files sit unencrypted on disk

With this setup:
- State lives in S3 - accessible to everyone, backed up automatically
- One source of truth - entire team works from same state
- Automatic locking - second person gets blocked if someone is already running
- Versioning enabled - roll back to any previous state version
- Encrypted at rest - secrets are protected

## What Gets Created

- **S3 Bucket** - stores the terraform.tfstate file
- **S3 Versioning** - keeps history of all state changes
- **S3 Encryption** - AES256 encryption for state files
- **DynamoDB Table** - handles state locking (legacy approach, kept for reference)
- **Backend Config** - uses modern `use_lockfile` for S3-native locking

### Infrastructure Verification

#### Remote State File in S3
<img src="screenshots/s3-bucket.png" width="600" alt="S3 Bucket"/>
*Displays the JSON state file contents inside the S3 bucket.*

#### S3 State File Versioning
<img src="screenshots/state-file-versioning.png" width="600" alt="State File Versioning"/>
*Shows the full version history and backup tracking of the state file.*

#### DynamoDB Table State Lock
<img src="screenshots/dynamodb-table.png" width="600" alt="DynamoDB Table"/>
*Returns the details and provisioning status of the DynamoDB lock table.*

## How to Use

1. Clone this repo
2. Update `variables.tf` with your own bucket name (must be globally unique)
3. Run `terraform init`
4. Run `terraform apply` - creates S3 bucket and DynamoDB table
5. State is now stored locally, run `terraform init -migrate-state` to move it to S3
6. Confirm migration when prompted

## Testing the Lock

Create a fake lock file:
```bash
echo '{"ID":"test","Operation":"apply","Who":"test@test.com","Created":"2024-01-01T00:00:00Z"}' | aws s3 cp - s3://YOUR-BUCKET-NAME/project24/terraform.tfstate.tflock
```

Try to run `terraform apply` - it will fail with a lock error.

### Terraform lock image
<img src="screenshots/lock-error.png" width="600" alt="Lock Error"/>
Shows lock error with details about who holds the lock.


Remove the fake lock:
```bash
aws s3 rm s3://YOUR-BUCKET-NAME/project24/terraform.tfstate.tflock
```

## Tools Used

- Terraform
- AWS S3
- AWS DynamoDB
- AWS CLI

## Files

- `main.tf` - S3 bucket and DynamoDB table resources
- `backend.tf` - backend configuration for remote state
- `variables.tf` - configurable values
- `outputs.tf` - displays created resource names