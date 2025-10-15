# ======================================
# Provider Configuration
# ======================================
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Recommended: Configure backend for state management in production
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "ensar-education/prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}

# ======================================
# Data Sources
# ======================================
data "aws_availability_zones" "available" {
  state = "available"
}

# ======================================
# Networking Module
# ======================================
module "networking" {
  source = "../../modules/networking"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# ======================================
# Frontend Module
# ======================================
module "frontend" {
  source = "../../modules/frontend"

  project_name       = var.project_name
  environment        = var.environment
  domain_name        = "${var.frontend_subdomain}-${var.project_name}.${var.domain_base}"
  route53_zone_id    = var.route53_zone_id
  create_certificate = true

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ======================================
# Backend Module
# ======================================
module "backend" {
  source = "../../modules/backend"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.networking.vpc_id
  public_subnet_ids   = module.networking.public_subnet_ids
  private_subnet_ids  = module.networking.private_subnet_ids  # Use private subnets for production security
  domain_name         = "${var.backend_subdomain}-${var.project_name}.${var.domain_base}"
  route53_zone_id     = var.route53_zone_id

  container_port              = var.container_port
  task_memory                 = var.task_memory
  instance_type               = var.instance_type
  ecs_ami                     = var.ecs_ami
  key_name                    = var.key_name
  desired_count               = var.desired_count
  min_instance_count          = var.min_instance_count
  max_instance_count          = var.max_instance_count
  desired_instance_count      = var.desired_instance_count
  health_check_path           = var.health_check_path
  log_retention_days          = var.log_retention_days
  enable_container_insights   = var.enable_container_insights

  environment_variables = var.environment_variables

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
