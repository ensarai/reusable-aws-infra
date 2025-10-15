variable "aws_region" { default = "us-east-1" }
variable "project_name" {}
variable "environment" { default = "dev" }

variable "ecr_repository_name" {}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "container_name" {}

variable "github_repository" {
  description = "Format: org/repo"
}
variable "github_branch" { default = "develop" }

variable "codebuild_compute_type" { default = "BUILD_GENERAL1_SMALL" }
variable "codebuild_image" { default = "aws/codebuild/standard:7.0" }
