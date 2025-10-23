variable "environment" {
  description = "Environment name"
  type        = string
  default     = "Production"

  validation {
    condition     = contains(["Development", "Staging", "Production"], var.environment)
    error_message = "Environment must be one of: Development, Staging, Production."
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least 2 availability zones must be specified for high availability."
  }
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "mpath-production-vpc"

  validation {
    condition     = length(var.vpc_name) > 0 && length(var.vpc_name) <= 255
    error_message = "VPC name must be between 1 and 255 characters long."
  }
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "192.168.29.0/24"
}

variable "internet_gateway_name" {
  description = "Name of the Internet Gateway"
  type        = string
  default     = "mpath-production-igw"

  validation {
    condition     = length(var.internet_gateway_name) > 0 && length(var.internet_gateway_name) <= 255
    error_message = "Internet Gateway name must be between 1 and 255 characters long."
  }
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
  default     = "mpath-production-nat-gateway"

  validation {
    condition     = length(var.nat_gateway_name) > 0 && length(var.nat_gateway_name) <= 255
    error_message = "NAT Gateway name must be between 1 and 255 characters long."
  }
}

variable "waf_allowed_countries" {
  description = "List of allowed country codes for WAF geo restriction"
  type        = list(string)
  default     = ["US"]
}

variable "tags" {
  description = "A map of tags to apply to all shared resources"
  type        = map(string)
  default     = {}
}
