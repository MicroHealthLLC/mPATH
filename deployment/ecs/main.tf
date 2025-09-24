terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  backend "s3" {} # init with -backend-config=backend-prod.hcl
}

provider "aws" { region = var.aws_region }

locals {
  app_name = "mpath"
  common_tags = merge(var.tags, {
    Project = "mpath"
    Environment = "shared-network"
    ManagedBy = "Terraform"
  })
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(local.common_tags, { Name = var.vpc_name })
}

# IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = var.internet_gateway_name })
}

# Public subnets
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    Tier = "public"
  })
}

# Private subnets
resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, count.index + 10)
  availability_zone = var.availability_zones[count.index]
  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-private-${count.index + 1}"
    Tier = "private"
  })
}

# NAT (single-AZ cost saver)
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(local.common_tags, { Name = "${var.nat_gateway_name}-eip" })
  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = merge(local.common_tags, { Name = var.nat_gateway_name })
  depends_on    = [aws_internet_gateway.main]
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route { cidr_block = "0.0.0.0/0"; gateway_id = aws_internet_gateway.main.id }
  tags = merge(local.common_tags, { Name = "${var.vpc_name}-public-rt" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route { cidr_block = "0.0.0.0/0"; nat_gateway_id = aws_nat_gateway.main.id }
  tags = merge(local.common_tags, { Name = "${var.vpc_name}-private-rt" })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Outputs (env stacks will read these)
output "vpc_id" {
  description = "Shared VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for ALBs"
  value       = aws_subnet.public[*].id
}
