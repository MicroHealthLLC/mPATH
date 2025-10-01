# Minimal, low-blocking WebACL
resource "aws_wafv2_web_acl" "mpath_web_acl" {
  name        = "${var.environment}-${local.app_name}-web-acl"
  description = "${var.environment} ${local.app_name} WebACL"
  scope       = "REGIONAL"

  default_action { allow {} }


  rule {
    name     = "block-non-allowed-countries"
    priority = 0
    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = var.waf_allowed_countries  # e.g., ["US"]
          }
        }
      }
    }
    action { block {} }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "block-non-allowed-countries"
    }
  }

  # 2) Block known bad IPs (very low false-positive)
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    override_action { none {} } # enforce block
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  # 3) Common rules in COUNT mode (observe first, then enforce later)
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 2
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    override_action { count {} } # low-risk: no blocking yet
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}-${local.app_name}-web-acl"
  }

  tags = local.common_tags
}
