variable "project_name" {
  description = "Project identifier used to name all resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "domain_base" {
  description = "Base domain for frontend and backend (e.g., ensarhr.com)"
  type        = string
}

variable "backend_subdomain" {
  description = "Subdomain prefix for backend API"
  type        = string
  default     = "api"
}

variable "frontend_subdomain" {
  description = "Subdomain prefix for frontend UI"
  type        = string
  default     = "ui"
}

variable "route53_zone_id" {
  description = "Hosted zone ID in Route53"
  type        = string
}

# ECS Configuration
variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 5000
}

variable "task_memory" {
  description = "Memory for the container in MB"
  type        = number
  default     = 256
}

variable "instance_type" {
  description = "EC2 instance type for ECS"
  type        = string
  default     = "t3.micro"
}

variable "ecs_ami" {
  description = "ECS-optimized AMI ID (leave empty for latest)"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "min_instance_count" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 1
}

variable "max_instance_count" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 1
}

variable "desired_instance_count" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "Health check path for the ALB target group"
  type        = string
  default     = "/actuator/health"
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 3
}

variable "enable_container_insights" {
  description = "Enable Container Insights for ECS cluster"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}
