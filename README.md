# Reusable AWS Infrastructure with Terraform

This repository contains a modular and reusable AWS infrastructure setup using Terraform. It supports deploying a complete full-stack application with separate frontend (S3 + CloudFront) and backend (ECS + ALB) infrastructure, along with CI/CD pipelines for automated deployments.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Deployment Guide](#deployment-guide)
  - [Step 1: Deploy Infrastructure](#step-1-deploy-infrastructure)
  - [Step 2: Setup CI/CD Pipelines](#step-2-setup-cicd-pipelines)
- [Cost Optimization](#cost-optimization)
- [Environments](#environments)
- [Cleanup](#cleanup)

## Architecture Overview

This infrastructure deploys a complete cloud-native application with:

**Frontend (Static Web Application)**
- S3 bucket for hosting static files
- CloudFront CDN for global content delivery
- ACM certificate for HTTPS
- Route53 DNS records

**Backend (API Service)**
- ECS cluster with EC2 instances (cost-optimized)
- Application Load Balancer (ALB)
- ECR repository for Docker images
- Auto Scaling Group for EC2 instances
- ACM certificate for HTTPS
- Route53 DNS records

**Networking**
- VPC with public and private subnets
- NAT gateways for private subnet internet access
- Security groups for ALB and ECS instances

**CI/CD Pipelines**
- CodePipeline for automated deployments
- CodeBuild for building applications
- GitHub integration via CodeStar Connections

## Project Structure

```
reusable-aws-infra/
├── modules-aws-infra/          # Reusable Terraform modules
│   ├── backend/                # ECS, ALB, ECR module
│   ├── frontend/               # S3, CloudFront module
│   └── networking/             # VPC, Subnets, NAT module
│
├── infra-three-env/            # Environment-specific infrastructure
│   ├── dev/                    # Development environment
│   ├── test/                   # Test/staging environment
│   └── prod/                   # Production environment
│
├── api-codepipeline/           # Backend API CI/CD pipeline
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform-{env}.tfvars
│
└── ui-codepipeline/            # Frontend UI CI/CD pipeline
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── terraform-{env}.tfvars
```

## Prerequisites

Before you begin, ensure you have the following:

1. **AWS Account** with appropriate permissions
2. **Terraform** installed (version >= 1.0)
   ```bash
   # Install Terraform
   # Visit: https://developer.hashicorp.com/terraform/downloads
   terraform --version
   ```

3. **AWS CLI** configured with credentials
   ```bash
   # Install AWS CLI
   # Visit: https://aws.amazon.com/cli/

   # Configure AWS credentials
   aws configure
   ```

4. **Route53 Hosted Zone** for your domain
   - Create a hosted zone in Route53 for your domain (e.g., `example.com`)
   - Note the Zone ID (you'll need this for configuration)

5. **GitHub Repository** for your application code
   - Frontend repository with `buildspec-frontend.yml`
   - Backend repository with `buildspec.yml`

6. **EC2 Key Pair** (optional, for SSH access to ECS instances)
   ```bash
   # Create a key pair in AWS console or via CLI
   aws ec2 create-key-pair --key-name your-keypair --query 'KeyMaterial' --output text > your-keypair.pem
   chmod 400 your-keypair.pem
   ```

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd reusable-aws-infra

# Deploy development environment infrastructure
cd infra-three-env/dev
terraform init
terraform plan
terraform apply

# After infrastructure is deployed, set up CI/CD pipelines
cd ../../api-codepipeline
terraform init
terraform apply -var-file=terraform-dev.tfvars

cd ../ui-codepipeline
terraform init
terraform apply -var-file=terraform-dev.tfvars
```

## Deployment Guide

### Step 1: Deploy Infrastructure

Deploy the infrastructure for your desired environment (dev, test, or prod).

#### 1.1. Configure Variables

Navigate to the environment folder and edit `terraform.tfvars`:

```bash
cd infra-three-env/dev
```

Edit `terraform.tfvars` with your configuration:

```hcl
# Project Configuration
project_name = "your-project-name"
environment  = "dev"

# AWS Configuration
aws_region = "us-east-1"

# Domain Configuration
domain_base        = "example.com"          # Your domain
backend_subdomain  = "api"                  # Creates: api-dev-your-project.example.com
frontend_subdomain = "ui"                   # Creates: ui-dev-your-project.example.com

# Route53
route53_zone_id = "Z0123456789ABCDEF"      # Your Route53 hosted zone ID

# ECS Configuration (adjust based on your needs)
instance_type          = "t3.micro"         # EC2 instance type
key_name               = "your-keypair"     # Your EC2 key pair name (optional)
task_memory            = 256                # Container memory in MB
container_port         = 5000               # Your application port
desired_count          = 1                  # Number of ECS tasks
min_instance_count     = 1                  # Min EC2 instances
max_instance_count     = 2                  # Max EC2 instances
desired_instance_count = 1                  # Desired EC2 instances

# Health Check
health_check_path = "/actuator/health"      # Your health check endpoint

# CloudWatch
log_retention_days        = 3               # Log retention in days
enable_container_insights = false           # Enable for detailed metrics (costs extra)

# Environment Variables (passed to your container)
environment_variables = {
  ENVIRONMENT = "dev"
  LOG_LEVEL   = "DEBUG"
}
```

#### 1.2. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply

# Type 'yes' when prompted to confirm
```

This will create:
- VPC with public/private subnets (if using networking module)
- ECS cluster with EC2 instances
- Application Load Balancer
- ECR repository for Docker images
- S3 bucket for frontend
- CloudFront distribution
- Route53 DNS records
- ACM certificates (with automatic DNS validation)

**Note**: Certificate validation can take 5-10 minutes. Terraform will wait for validation to complete.

#### 1.3. Note the Outputs

After deployment, Terraform will output important values:

```bash
# View outputs
terraform output

# Example outputs:
# backend_alb_dns_name = "project-dev-alb-123456789.us-east-1.elb.amazonaws.com"
# backend_domain_name = "api-dev-project.example.com"
# backend_ecr_repository_url = "123456789.dkr.ecr.us-east-1.amazonaws.com/project-dev-backend"
# frontend_bucket_name = "project-dev-ui-bucket"
# frontend_cloudfront_domain = "d1234567890abc.cloudfront.net"
# frontend_domain_name = "ui-dev-project.example.com"
```

**Save these outputs** - you'll need them for CI/CD pipeline setup.

### Step 2: Setup CI/CD Pipelines

After infrastructure is deployed, set up automated CI/CD pipelines.

#### 2.1. Deploy Backend API Pipeline

```bash
cd ../../api-codepipeline
```

Edit `terraform-dev.tfvars` with your configuration:

```hcl
# Project Configuration
project_name = "your-project-name"
environment  = "dev"
aws_region   = "us-east-1"

# GitHub Configuration
github_repository = "your-org/backend-repo"    # Format: owner/repo-name
github_branch     = "main"                     # Branch to deploy

# ECR Configuration (from infrastructure outputs)
ecr_repository_name = "your-project-dev-backend"

# ECS Configuration (from infrastructure outputs)
ecs_cluster_name = "your-project-dev-cluster"
ecs_service_name = "your-project-dev-backend-service"
container_name   = "your-project-dev-backend"

# CodeBuild Configuration
codebuild_compute_type = "BUILD_GENERAL1_SMALL"
codebuild_image        = "aws/codebuild/standard:5.0"
```

Deploy the pipeline:

```bash
# Initialize Terraform
terraform init

# Apply the configuration
terraform apply -var-file=terraform-dev.tfvars
```

**Important**: After deployment, you must activate the GitHub connection:
1. Go to AWS Console → CodePipeline → Settings → Connections
2. Find the connection that was created
3. Click "Update pending connection"
4. Complete the GitHub authorization flow

#### 2.2. Deploy Frontend UI Pipeline

```bash
cd ../ui-codepipeline
```

Edit `terraform-dev.tfvars` with your configuration:

```hcl
# Project Configuration
project_name = "your-project-name"
environment  = "dev"
aws_region   = "us-east-1"

# GitHub Configuration
github_repository = "your-org/frontend-repo"   # Format: owner/repo-name
github_branch     = "main"                     # Branch to deploy

# Frontend Infrastructure (from infrastructure outputs)
frontend_bucket_name        = "your-project-dev-ui-bucket"
cloudfront_distribution_id  = "E1234567890ABC"

# CodeBuild Configuration
codebuild_compute_type = "BUILD_GENERAL1_SMALL"
codebuild_image        = "aws/codebuild/standard:5.0"
```

Deploy the pipeline:

```bash
# Initialize Terraform
terraform init

# Apply the configuration
terraform apply -var-file=terraform-dev.tfvars
```

**Important**: Activate the GitHub connection as described in step 2.1.

#### 2.3. Prepare Your Application Code

**Backend Repository** - Create `buildspec.yml`:

```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH:=latest}
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $REPOSITORY_URI:latest .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo Writing image definitions file...
      - printf '[{"name":"%s","imageUri":"%s"}]' $CONTAINER_NAME $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json

artifacts:
  files: imagedefinitions.json
```

**Frontend Repository** - Create `buildspec-frontend.yml`:

```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 18
    commands:
      - echo Installing dependencies...
      - npm install
  build:
    commands:
      - echo Build started on `date`
      - echo Building the application...
      - npm run build
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Deploying to S3...
      - aws s3 sync build/ s3://$S3_BUCKET_NAME --delete
      - echo Invalidating CloudFront cache...
      - aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/*"

artifacts:
  files:
    - '**/*'
  base-directory: build
```

#### 2.4. Test the Pipeline

Push changes to your GitHub repository to trigger the pipeline:

```bash
git add .
git commit -m "Test pipeline deployment"
git push origin main
```

Monitor the pipeline in AWS Console:
- Go to AWS Console → CodePipeline
- Watch the Source → Build → Deploy stages
- Check CloudWatch Logs for build output

## Cost Optimization

The infrastructure is designed to be cost-effective, especially for dev/test environments.

### Development Environment (~$28-30/month)
- **EC2 t3.micro**: ~$7.30/month (Free Tier eligible for first 12 months)
- **Application Load Balancer**: ~$16.20/month
- **CloudFront**: ~$1.00/month (minimal usage)
- **S3**: ~$0.10/month
- **Route53**: ~$1.00/month
- **ECR**: ~$0.50/month
- **CloudWatch Logs**: ~$0.50/month
- **Data Transfer**: ~$2.00/month

### Cost Reduction Tips

1. **Use Default VPC** (already configured in dev environment)
   - Saves ~$33/month by avoiding NAT Gateway costs
   - Default VPC has free internet gateway

2. **Stop EC2 Instances When Not in Use**
   ```bash
   # Stop instances (keeps data, only pay for storage)
   aws ecs update-service --cluster <cluster-name> --service <service-name> --desired-count 0
   aws autoscaling set-desired-capacity --auto-scaling-group-name <asg-name> --desired-capacity 0
   ```

3. **Disable Container Insights** (already disabled in dev)
   - Saves on CloudWatch costs

4. **Reduce Log Retention**
   - Dev: 3 days (configured)
   - Prod: 7-30 days (adjust as needed)

5. **Use Spot Instances** (optional, for non-critical workloads)
   - Can save up to 70% on EC2 costs
   - Requires additional configuration

## Environments

The repository supports three environments with the same structure:

### Development (dev)
- Cost-optimized configuration
- Single t3.micro instance
- Minimal log retention
- Suitable for development and testing

### Test/Staging (test)
- Similar to dev but isolated
- Can test changes before production
- May use slightly larger instances

### Production (prod)
- Production-grade configuration
- Higher instance counts
- Longer log retention
- Container Insights enabled
- Multi-AZ deployment for high availability

To deploy to different environments:

```bash
# Test environment
cd infra-three-env/test
terraform init
terraform apply

# Production environment
cd infra-three-env/prod
terraform init
terraform apply
```

## Cleanup

To avoid ongoing charges, destroy resources when no longer needed.

### Destroy in Reverse Order

**1. Destroy CI/CD Pipelines First**

```bash
# Destroy UI pipeline
cd ui-codepipeline
terraform destroy -var-file=terraform-dev.tfvars

# Destroy API pipeline
cd ../api-codepipeline
terraform destroy -var-file=terraform-dev.tfvars
```

**2. Empty S3 Buckets**

```bash
# Empty frontend bucket (required before destroy)
aws s3 rm s3://your-project-dev-ui-bucket --recursive

# Empty pipeline artifacts bucket
aws s3 rm s3://your-project-dev-pipeline-artifacts-<account-id> --recursive
```

**3. Destroy Infrastructure**

```bash
# Destroy dev environment
cd ../infra-three-env/dev
terraform destroy

# Type 'yes' when prompted
```

**4. Manual Cleanup (if needed)**

Some resources may require manual cleanup:
- **ECR repositories**: Delete images first, then repository
- **CloudWatch Log Groups**: May persist after destruction
- **Route53 records**: Check for any remaining records

```bash
# Delete ECR images
aws ecr batch-delete-image --repository-name your-project-dev-backend --image-ids imageTag=latest

# Delete ECR repository
aws ecr delete-repository --repository-name your-project-dev-backend --force

# Delete log groups
aws logs delete-log-group --log-group-name /ecs/your-project-dev-backend
```

## Troubleshooting

### Common Issues

**1. Certificate Validation Timeout**
- Ensure Route53 hosted zone is properly configured
- Check that name servers match Route53 NS records
- May take 5-10 minutes for DNS propagation

**2. ECS Tasks Not Starting**
- Check CloudWatch logs: `/ecs/<project-name>-<env>-backend`
- Verify ECR repository has Docker images
- Check security group rules allow ALB → ECS communication

**3. Pipeline Failing**
- Activate GitHub connection in AWS Console
- Verify buildspec.yml is in repository root
- Check CodeBuild logs in CloudWatch

**4. 502/503 Errors from ALB**
- Verify health check endpoint is accessible
- Check ECS tasks are running
- Verify container port matches ALB target group

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [AWS CodePipeline Documentation](https://docs.aws.amazon.com/codepipeline/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review CloudWatch logs for detailed error messages
3. Verify all prerequisites are met
4. Check AWS service quotas and limits

## License

This project is licensed under the MIT License - see the LICENSE file for details.
