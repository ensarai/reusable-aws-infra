# ======================================
# Production Environment Configuration
# Full high-availability setup
# ======================================

project_name = "ensar-education"
environment  = "prod"

# AWS Configuration
aws_region = "us-east-1"

# Domain Configuration
domain_base        = "ensarhr.com"
backend_subdomain  = "api"
frontend_subdomain = "ui"
# This will create:
# - Frontend: ui-ensar-education.ensarhr.com
# - Backend:  api-ensar-education.ensarhr.com

# Route53
route53_zone_id = "Z09173773OL1VHDJHF5UK"  # Replace with your hosted zone ID

# Networking Configuration (Custom VPC with HA)
vpc_cidr             = "10.2.0.0/16"
public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.11.0/24", "10.2.12.0/24"]

# ECS EC2 Configuration (Production-grade)
instance_type          = "t3.medium"        # $30.37/month per instance
ecs_ami                = ""                 # Auto-select latest ECS-optimized AMI
key_name               = "venkat-keypair"   # Optional: for SSH access
task_memory            = 1024               # 1 GB per task
container_port         = 5000
desired_count          = 3                  # 3 tasks for high availability
min_instance_count     = 3                  # 3 EC2 instances minimum
max_instance_count     = 6                  # 6 EC2 instances maximum (auto-scale)
desired_instance_count = 3                  # 3 EC2 instances

# Health Check Configuration
health_check_path = "/actuator/health"

# CloudWatch Configuration
log_retention_days        = 30              # 30 days retention for compliance
enable_container_insights = true            # Enable for production monitoring

# Environment Variables for Container
environment_variables = {
  ENVIRONMENT = "production"
  LOG_LEVEL   = "WARN"
}

# ======================================
# Cost Breakdown (Estimated Monthly):
# ======================================
# - EC2 t3.medium × 3:       ~$91.11
# - ALB:                     ~$16.20
# - NAT Gateway × 2:         ~$65.70
# - NAT Data Transfer:       ~$22.50
# - CloudFront:              ~$20.00
# - S3:                      ~$1.00
# - Route53:                 ~$1.00
# - ECR:                     ~$2.00
# - CloudWatch Logs:         ~$10.00
# - Container Insights:      ~$5.00
# - Data Transfer:           ~$15.00
# ======================================
# TOTAL:                     ~$250/month
# ======================================
#
# Production Features:
# ✅ High Availability (3 instances across 2 AZs)
# ✅ Private subnets with NAT Gateways (secure)
# ✅ Auto Scaling (3-6 instances)
# ✅ Container Insights enabled
# ✅ 30-day log retention
# ✅ Production-grade monitoring
#
# Cost Optimization for Production:
# 1. Use Reserved Instances (1-year): save ~40% → $174/month
# 2. Use Savings Plans (1-year): save ~40% → $174/month
# 3. Use Reserved Instances (3-year): save ~60% → $136/month
# 4. Optimize during off-peak: Auto-scale down to 2 instances
#
# Security Best Practices (Enabled):
# ✅ Private subnets for ECS instances
# ✅ NAT Gateways for outbound traffic
# ✅ Multi-AZ deployment
# ✅ HTTPS only (ACM certificates)
# ✅ Container Insights monitoring
# ✅ Extended log retention
