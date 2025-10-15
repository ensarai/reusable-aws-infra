# ======================================
# Dev Environment Configuration
# Cost-Optimized for < $30/month
# ======================================

project_name = "ensar-education"
environment  = "dev"

# AWS Configuration
aws_region = "us-east-1"

# Domain Configuration
domain_base        = "ensarhr.com"
backend_subdomain  = "api"
frontend_subdomain = "ui"
# This will create:
# - Frontend: ui-dev-ensar-education.ensarhr.com
# - Backend:  api-dev-ensar-education.ensarhr.com

# Route53
route53_zone_id = "Z09173773OL1VHDJHF5UK"  # Replace with your hosted zone ID

# ECS EC2 Configuration (Cost-Optimized)
instance_type          = "t3.micro"         # $7.30/month (on-demand)
ecs_ami                = ""                 # Auto-select latest ECS-optimized AMI
key_name               = "venkat-keypair"   # Optional: for SSH access
task_memory            = 256                # MB - minimal for dev
container_port         = 5000
desired_count          = 1                  # 1 task
min_instance_count     = 1                  # 1 EC2 instance minimum
max_instance_count     = 1                  # 1 EC2 instance maximum
desired_instance_count = 1                  # 1 EC2 instance

# Health Check Configuration
health_check_path = "/actuator/health"

# CloudWatch Configuration
log_retention_days        = 3               # Minimal retention to save costs
enable_container_insights = false           # Disable to save costs

# Environment Variables for Container
environment_variables = {
  ENVIRONMENT = "dev"
  LOG_LEVEL   = "DEBUG"
}

# ======================================
# Cost Breakdown (Estimated Monthly):
# ======================================
# - EC2 t3.micro:            ~$7.30
# - ALB:                     ~$16.20
# - CloudFront (minimal):    ~$1.00
# - S3 (minimal):            ~$0.10
# - Route53:                 ~$1.00
# - ECR:                     ~$0.50
# - CloudWatch Logs:         ~$0.50
# - Data Transfer:           ~$2.00
# ======================================
# TOTAL:                     ~$28.60/month
# ======================================
#
# Notes:
# - Using default VPC (no NAT Gateway = save $33/month)
# - t3.micro is free tier eligible (750 hrs/month first 12 months)
# - ALB has no free tier
# - Can stop EC2 instance when not in use to save costs
