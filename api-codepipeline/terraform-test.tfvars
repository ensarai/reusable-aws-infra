# Test/Staging Environment Configuration
project_name        = "hr-api"
environment         = "test"
aws_region          = "us-east-1"

# ECR & ECS Configuration (Test)
ecr_repository_name = "hr-api-test"
ecs_cluster_name    = "hr-api-ec2-cluster-test"
ecs_service_name    = "hr-api-app-test"
container_name      = "hr-api"

# GitHub Configuration (Test/Release Branch)
github_repository   = "nproducts3/hr-api"
github_branch       = "release"

# CodeBuild Configuration (Medium for test)
codebuild_compute_type = "BUILD_GENERAL1_MEDIUM"
codebuild_image        = "aws/codebuild/standard:7.0"
