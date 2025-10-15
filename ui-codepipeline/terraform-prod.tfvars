# Production Environment Configuration - Frontend Pipeline
project_name = "ensar-education"
environment  = "prod"
aws_region   = "us-east-1"

# S3 & CloudFront Configuration
# Get these values from the frontend infrastructure outputs:
#   cd ../environments/prod && terraform output frontend_bucket_name
#   cd ../environments/prod && terraform output frontend_cloudfront_distribution_id
frontend_bucket_name         = "ensar-education-prod-ui-bucket"
cloudfront_distribution_id   = "ENTER_YOUR_CLOUDFRONT_DISTRIBUTION_ID_HERE"  # e.g., E9012QRSTUVWX

# GitHub Configuration (Main Branch)
github_repository = "YOUR_GITHUB_ORG/YOUR_FRONTEND_REPO"  # e.g., "nproducts3/hr-ui"
github_branch     = "main"

# CodeBuild Configuration (Medium for production)
codebuild_compute_type = "BUILD_GENERAL1_MEDIUM"
codebuild_image        = "aws/codebuild/standard:7.0"
