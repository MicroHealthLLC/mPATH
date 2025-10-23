# Minimal, low-blocking WebACL
resource "aws_wafv2_web_acl" "mpath_web_acl" {
  name        = "${var.environment}-${local.app_name}-web-acl"
  description = "${var.environment} ${local.app_name} WebACL"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # 1) Allow-only list of countries; everything else is blocked
  rule {
    name     = "block-non-allowed-countries"
    priority = 0

    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = var.waf_allowed_countries # e.g., ["US"]
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

  # 2) AWS managed IP reputation (enforced)
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }

    # 'none' = respect the rule group's native action (block)
    override_action {
      none {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
    }
  }

  # 3) Common rules in COUNT mode (observe first)
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 2

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }

    # 'count' = do not block yet; just record matches
    override_action {
      count {}
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
    }
  }

  # Web ACL level visibility
  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}-${local.app_name}-web-acl"
  }

  tags = local.common_tags
}
