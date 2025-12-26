terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {} # init with: terraform init -backend-config=backend.hcl
}

provider "aws" {
  region = var.aws_region
}

# Pull shared network from the ROOT stack
data "terraform_remote_state" "root" {
  backend = "s3"
  config = {
    bucket  = "mpath-prod-terraform-remote-state"
    key     = "mpath/vpc/terraform.tfstate"
    region  = var.aws_region
    encrypt = true
  }
}

locals {
  vpc_id             = data.terraform_remote_state.root.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.root.outputs.private_subnet_ids
  public_subnet_ids  = data.terraform_remote_state.root.outputs.public_subnet_ids

  tags = {
    ManagedBy = "Terraform"
  }
}

module "twingate_connector" {
  source = "../../modules/twingate-connector"

  # Network wiring
  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids


  # Place the connector in private subnets, no public IP
  assign_public_ip = false

  # Task sizing
  desired_count = 1
  cpu           = 1024
  memory        = 2048
  env           = var.env

  # Secrets
  twingate_secret_path = var.twingate_secret_path

  # Hardening
  readonly_root_filesystem = var.readonly_root_filesystem

  tags = merge(local.tags, {
    Service = "TwingateConnector"
  })
}
