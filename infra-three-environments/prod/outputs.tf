# ======================================
# Networking Outputs
# ======================================
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnet_ids
}

# ======================================
# Frontend Outputs
# ======================================
output "frontend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  value       = module.frontend.bucket_name
}

output "frontend_cloudfront_url" {
  description = "CloudFront URL for the frontend"
  value       = module.frontend.cloudfront_url
}

output "frontend_cloudfront_distribution_id" {
  description = "CloudFront Distribution ID for cache invalidation"
  value       = module.frontend.cloudfront_distribution_id
}

output "frontend_domain" {
  description = "Custom domain for frontend"
  value       = module.frontend.frontend_domain
}

output "frontend_url" {
  description = "Full frontend URL"
  value       = module.frontend.frontend_url
}

# ======================================
# Backend Outputs
# ======================================
output "backend_ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.backend.ecr_repository_url
}

output "backend_ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.backend.ecs_cluster_name
}

output "backend_ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.backend.ecs_service_name
}

output "backend_alb_dns_name" {
  description = "DNS name of the backend Application Load Balancer"
  value       = module.backend.alb_dns_name
}

output "backend_domain" {
  description = "Custom domain for backend API"
  value       = module.backend.backend_domain
}

output "backend_url" {
  description = "Full backend URL"
  value       = module.backend.backend_url
}

output "backend_target_group_arn" {
  description = "ARN of the backend target group"
  value       = module.backend.target_group_arn
}

output "backend_certificate_arn" {
  description = "ARN of the backend ACM certificate"
  value       = module.backend.certificate_arn
}

output "backend_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.backend.log_group_name
}

output "backend_autoscaling_group_name" {
  description = "Name of the Auto Scaling group"
  value       = module.backend.autoscaling_group_name
}
