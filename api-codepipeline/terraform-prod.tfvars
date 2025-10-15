# Production Environment Configuration
project_name        = "hr-api"
environment         = "prod"
aws_region          = "us-east-1"

# ECR & ECS Configuration (Production)
ecr_repository_name = "hr-api-prod"
ecs_cluster_name    = "hr-api-ec2-cluster-prod"
ecs_service_name    = "hr-api-app-prod"
container_name      = "hr-api"

# GitHub Configuration (Production/Main Branch)
github_repository   = "nproducts3/hr-api"
github_branch       = "main"

# CodeBuild Configuration (Larger for prod)
codebuild_compute_type = "BUILD_GENERAL1_MEDIUM"
codebuild_image        = "aws/codebuild/standard:7.0"
