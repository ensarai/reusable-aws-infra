# Test Environment Configuration - Frontend Pipeline
project_name = "ensar-education"
environment  = "test"
aws_region   = "us-east-1"

# S3 & CloudFront Configuration
# Get these values from the frontend infrastructure outputs:
#   cd ../environments/test && terraform output frontend_bucket_name
#   cd ../environments/test && terraform output frontend_cloudfront_distribution_id
frontend_bucket_name         = "ensar-education-test-ui-bucket"
cloudfront_distribution_id   = "ENTER_YOUR_CLOUDFRONT_DISTRIBUTION_ID_HERE"  # e.g., E5678IJKLMNOP

# GitHub Configuration (Release Branch)
github_repository = "YOUR_GITHUB_ORG/YOUR_FRONTEND_REPO"  # e.g., "nproducts3/hr-ui"
github_branch     = "release"

# CodeBuild Configuration (Medium for test)
codebuild_compute_type = "BUILD_GENERAL1_MEDIUM"
codebuild_image        = "aws/codebuild/standard:7.0"
