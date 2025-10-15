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

  # Optional: Configure backend for state management
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "ensar-education/dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}

# ======================================
# Data Sources - Use Default VPC
# ======================================
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  # Exclude us-east-1e (t3.micro not available there)
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}

# ======================================
# Frontend Module
# ======================================
module "frontend" {
  source = "../../modules-aws-infra/frontend"

  project_name       = var.project_name
  environment        = var.environment
  domain_name        = "${var.frontend_subdomain}-${var.environment}-${var.project_name}.${var.domain_base}"
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
  source = "../../modules-aws-infra/backend"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = data.aws_vpc.default.id
  public_subnet_ids   = slice(data.aws_subnets.default.ids, 0, 2)
  private_subnet_ids  = slice(data.aws_subnets.default.ids, 0, 2)  # Use public subnets (no NAT cost)
  domain_name         = "${var.backend_subdomain}-${var.environment}-${var.project_name}.${var.domain_base}"
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
