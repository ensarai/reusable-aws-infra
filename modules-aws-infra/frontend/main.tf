# ======================================
# S3 Bucket for Frontend
# ======================================
resource "aws_s3_bucket" "frontend" {
  bucket        = "${var.project_name}-${var.environment}-ui-bucket"
  force_destroy = true

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-ui-bucket"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = "${aws_s3_bucket.frontend.arn}/*"
    }]
  })
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# ======================================
# ACM Certificate for Frontend
# ======================================
resource "aws_acm_certificate" "frontend" {
  count             = var.create_certificate ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-frontend-cert"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.create_certificate ? {
    for dvo in aws_acm_certificate.frontend[0].domain_validation_options : dvo.domain_name => dvo
  } : {}

  zone_id = var.route53_zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "frontend" {
  count                   = var.create_certificate ? 1 : 0
  certificate_arn         = aws_acm_certificate.frontend[0].arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

# ======================================
# CloudFront Distribution
# ======================================
resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id   = "s3-frontend-origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = var.create_certificate ? [var.domain_name] : []

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-frontend-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = var.create_certificate ? aws_acm_certificate_validation.frontend[0].certificate_arn : null
    ssl_support_method       = var.create_certificate ? "sni-only" : null
    minimum_protocol_version = var.create_certificate ? "TLSv1.2_2021" : "TLSv1"
    cloudfront_default_certificate = !var.create_certificate
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-frontend-cdn"
      Environment = var.environment
    },
    var.tags
  )
}

# ======================================
# Route53 A Record for Frontend
# ======================================
resource "aws_route53_record" "frontend" {
  count   = var.create_certificate ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
