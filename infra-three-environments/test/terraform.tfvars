# ======================================
# Test Environment Configuration
# Moderate cost optimization (~$80/month)
# ======================================

project_name = "ensar-education"
environment  = "test"

# AWS Configuration
aws_region = "us-east-1"

# Domain Configuration
domain_base        = "ensarhr.com"
backend_subdomain  = "api"
frontend_subdomain = "ui"
# This will create:
# - Frontend: ui-test-ensar-education.ensarhr.com
# - Backend:  api-test-ensar-education.ensarhr.com

# Route53
route53_zone_id = "Z09173773OL1VHDJHF5UK"  # Replace with your hosted zone ID

# Networking Configuration (Custom VPC)
vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]

# ECS EC2 Configuration
instance_type          = "t3.small"         # $14.60/month per instance
ecs_ami                = ""                 # Auto-select latest ECS-optimized AMI
key_name               = "venkat-keypair"   # Optional: for SSH access
task_memory            = 512                # MB per task
container_port         = 5000
desired_count          = 2                  # 2 tasks for high availability
min_instance_count     = 2                  # 2 EC2 instances minimum
max_instance_count     = 3                  # 3 EC2 instances maximum
desired_instance_count = 2                  # 2 EC2 instances

# Health Check Configuration
health_check_path = "/actuator/health"

# CloudWatch Configuration
log_retention_days        = 7               # 7 days retention
enable_container_insights = false           # Disable to save costs

# Environment Variables for Container
environment_variables = {
  ENVIRONMENT = "test"
  LOG_LEVEL   = "INFO"
}

# ======================================
# Cost Breakdown (Estimated Monthly):
# ======================================
# - EC2 t3.small × 2:        ~$29.20
# - ALB:                     ~$16.20
# - NAT Gateway × 2:         ~$65.70
# - NAT Data Transfer:       ~$9.00
# - CloudFront:              ~$5.00
# - S3:                      ~$0.20
# - Route53:                 ~$1.00
# - ECR:                     ~$1.00
# - CloudWatch Logs:         ~$2.00
# - Data Transfer:           ~$5.00
# ======================================
# TOTAL:                     ~$134/month
# ======================================
#
# Cost Optimization Options:
# 1. Use public subnets (no NAT) = save $75/month → $59/month
# 2. Use 1 NAT Gateway instead of 2 = save $33/month → $101/month
# 3. Use t3.micro instead = save $15/month → $119/month
#
# Notes:
# - Currently uses public subnets to avoid NAT costs
# - For true HA, use private subnets with NAT Gateway
# - Can be stopped when not in use to save costs
