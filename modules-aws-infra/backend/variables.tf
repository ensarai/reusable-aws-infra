variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS instances"
  type        = list(string)
}

variable "domain_name" {
  description = "Custom domain name for the backend API (e.g., api-dev-project.example.com)"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 5000
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "task_memory" {
  description = "Memory for the container in MB (hard limit)"
  type        = number
  default     = 256
}

variable "instance_type" {
  description = "EC2 instance type for ECS"
  type        = string
  default     = "t3.micro"
}

variable "ecs_ami" {
  description = "AMI ID for ECS-optimized Amazon Linux 2"
  type        = string
  default     = ""  # Will use latest ECS-optimized AMI if not specified
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = ""
}

variable "min_instance_count" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 1
}

variable "max_instance_count" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 2
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

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive health checks successes required"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures required"
  type        = number
  default     = 2
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

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
