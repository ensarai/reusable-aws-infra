# Development Environment Configuration - Frontend Pipeline
project_name = "ensar-education"
environment  = "dev"
aws_region   = "us-east-1"

# S3 & CloudFront Configuration
# Get these values from the frontend infrastructure outputs:
#   cd ../environments/dev && terraform output frontend_bucket_name
#   cd ../environments/dev && terraform output frontend_cloudfront_distribution_id
frontend_bucket_name         = "ensar-education-dev-ui-bucket"
cloudfront_distribution_id   = ""  # e.g., E1234ABCDEFGH

# GitHub Configuration (Development Branch)
github_repository = "ensarai/ensar-education"  # Format: owner/repository
github_branch     = "main"

# CodeBuild Configuration (Smaller for dev)
codebuild_compute_type = "BUILD_GENERAL1_SMALL"
codebuild_image        = "aws/codebuild/standard:7.0"
