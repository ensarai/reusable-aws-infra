# Development Environment Configuration
project_name        = "ensar-education"
environment         = "dev"
aws_region          = "us-east-1"

# ECR & ECS Configuration (Development)
ecr_repository_name = "ensar-education-dev-backend"
ecs_cluster_name    = "ensar-education-dev-cluster"
ecs_service_name    = "ensar-education-dev-backend-service"
container_name      = "ensar-education-dev-backend"

# GitHub Configuration (Development Branch)
github_repository   = "ensarai/ensar-education"
github_branch       = "main"

# CodeBuild Configuration (Smaller for dev)
codebuild_compute_type = "BUILD_GENERAL1_SMALL"
codebuild_image        = "aws/codebuild/standard:7.0"
