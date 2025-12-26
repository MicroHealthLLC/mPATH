resource "aws_wafv2_web_acl" "mpath_web_acl" {
  name        = "${var.environment}-${local.app_name}-web-acl"
  description = "${var.environment} ${local.app_name} WebACL"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # 0) Geo allowlist
  rule {
    name     = "block-non-allowed-countries"
    priority = 0
    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = var.waf_allowed_countries
          }
        }
      }
    }
    action {
      block {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "block-non-allowed-countries"
    }
  }

  # 1) AWSManagedRulesAmazonIpReputationList
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
    }
  }

  # 2) AWSManagedRulesAnonymousIpList
  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 2
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAnonymousIpList"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
    }
  }

  # 3) AWSManagedRulesCommonRuleSet
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 3
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    override_action {
      count {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
    }
  }

  # 4) AWSManagedRulesAdminProtectionRuleSet
  rule {
    name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    priority = 4
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAdminProtectionRuleSet"
      }
    }
    override_action {
      count {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    }
  }

  # 5) AWSManagedRulesKnownBadInputsRuleSet
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 5
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }
    override_action {
      count {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    }
  }

  # 6) Block local username/password login (POST /users/sign_in)
  rule {
    name     = "block-local-signin-post"
    priority = 6

    statement {
      and_statement {
        statement {
          byte_match_statement {
            search_string         = "/users/sign_in"
            positional_constraint = "EXACTLY"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }

        statement {
          byte_match_statement {
            search_string         = "POST"
            positional_constraint = "EXACTLY"

            field_to_match {
              method {}
            }

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    action {
      block {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "block-local-signin-post"
    }
  }


  # 7) Block /users/password/new entirely
  rule {
    name     = "block-password-reset"
    priority = 7
    statement {
      byte_match_statement {
        search_string         = "/users/password/new"
        positional_constraint = "EXACTLY"
        field_to_match {
          uri_path {}
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }
    action {
      block {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "block-password-reset"
    }
  }
  # Block all OAuth sign-in / error callbacks
  rule {
    name     = "block-oauth-callbacks"
    priority = 8

    statement {
      byte_match_statement {
        search_string         = "/signin/oauth"
        positional_constraint = "STARTS_WITH"
        field_to_match {
          uri_path {}
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    action {
      block {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "block-oauth-callbacks"
    }
  }


  # 9) Allow ELB health checks
  rule {
    name     = "allow-elb-health-checks"
    priority = 9
    statement {
      byte_match_statement {
        search_string         = "ELB-HealthChecker"
        positional_constraint = "CONTAINS"
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }
    action {
      allow {}
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "allow-elb-health-checks"
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}-${local.app_name}-web-acl"
  }

  tags = local.common_tags
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "mpath_waf_logs" {
  name              = "aws-waf-logs-${var.environment}-${local.app_name}"
  retention_in_days = 30
  tags              = local.common_tags
}

# Logging Configuration
resource "aws_wafv2_web_acl_logging_configuration" "mpath_waf_logging" {
  resource_arn = aws_wafv2_web_acl.mpath_web_acl.arn

  log_destination_configs = [
    aws_cloudwatch_log_group.mpath_waf_logs.arn
  ]

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }

  redacted_fields {
    single_header {
      name = "cookie"
    }
  }
}
