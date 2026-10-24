# Remote state in S3 with native S3 locking (Terraform >= 1.10, no DynamoDB table needed).
# Replace the bucket name with the one you created in terraform/bootstrap.
terraform {
  backend "s3" {
    bucket       = "swarup-eks-gitops-tfstate"
    key          = "eks-gitops/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
