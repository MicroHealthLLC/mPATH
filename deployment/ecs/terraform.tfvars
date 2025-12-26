aws_region         = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]

# VPC
vpc_name              = "mpath-production-vpc"
vpc_cidr_block        = "192.168.29.0/24"
internet_gateway_name = "mpath-production-igw"
nat_gateway_name      = "mpath-production-nat-gateway"

# WAF (only if WAF is defined in root/waf.tf)
waf_allowed_countries = ["US"]

# Tags
tags = {
  Owner       = "Microhealth Platform Engineering"
  CostCenter  = "Engineering"
  Application = "mpath"
}