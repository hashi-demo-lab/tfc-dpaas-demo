## Place all your terraform resources here
#  Locals at the top (if you are using them)
#  Data blocks next to resources that are referencing them
#  Reduce hard coded inputs where possible. They are used below for simplicity to show structure

data "aws_availability_zones" "available" {}

locals {
  name   = "test-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  s3_prefix = "redshift/${local.name}/"

  tags = {
    Example    = local.name
    GithubRepo = "hashi-demo-lab/tfc-dpaas-demo"
  }

}

################################################################################
# Complete
################################################################################

module "redshift" {
  source = "terraform-aws-modules/redshift/aws"
  version = "5.4.0"
  cluster_identifier    = local.name
  allow_version_upgrade = true
  node_type             = "dc2.large"
  number_of_nodes       = 1

  database_name   = "mydb"
  master_username = "mydbuser"
  
  manage_master_password = true

  manage_master_password_rotation = false

  encrypted   = true
  kms_key_arn = aws_kms_key.redshift.arn

  enhanced_vpc_routing   = true
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_ids             = module.vpc.redshift_subnets

  # Only available when using the ra3.x type
  # availability_zone_relocation_enabled = true

  # snapshot_copy = {
  #   destination_region = var.secondary_region
  #   grant_name         = aws_redshift_snapshot_copy_grant.secondary.snapshot_copy_grant_name
  # }

  
  # Parameter group
  parameter_group_name        = "${local.name}-custom"
  parameter_group_description = "Custom parameter group for ${local.name} cluster"
  parameter_group_parameters = {
    wlm_json_configuration = {
      name = "wlm_json_configuration"
      value = jsonencode([
        {
          query_concurrency = 15
        }
      ])
    }
    require_ssl = {
      name  = "require_ssl"
      value = true
    }
    use_fips_ssl = {
      name  = "use_fips_ssl"
      value = false
    }
    enable_user_activity_logging = {
      name  = "enable_user_activity_logging"
      value = true
    }
    max_concurrency_scaling_clusters = {
      name  = "max_concurrency_scaling_clusters"
      value = 3
    }
    enable_case_sensitive_identifier = {
      name  = "enable_case_sensitive_identifier"
      value = true
    }
  }
  parameter_group_tags = {
    Additional = "CustomParameterGroup"
  }

  # Subnet group
  subnet_group_name        = "${local.name}-custom"
  subnet_group_description = "Custom subnet group for ${local.name} cluster"
  subnet_group_tags = {
    Additional = "CustomSubnetGroup"
  }
  # Usage limits
  
    tags = local.tags
  

  # Authentication profile
  # authentication_profiles = {
  #   example = {
  #     name = "example"
  #     content = {
  #       AllowDBUserOverride = "1"
  #       Client_ID           = "ExampleClientID"
  #       App_ID              = "example"
  #     }
  #   }
  #   bar = {
  #     content = {
  #       AllowDBUserOverride = "1"
  #       Client_ID           = "ExampleClientID"
  #       App_ID              = "bar"
  #     }
  #   }
  # }
}

################################################################################
# Add tags to managed secret created by redshift
################################################################################

data "aws_secretsmanager_secret" "redshift_password" {
    arn = module.redshift.master_password_secret_arn
    depends_on = [ module.redshift ]

}
resource "terraform_data" "secret_manager_tags" {

  provisioner "local-exec" {
    command = "aws secretsmanager tag-resource --secret-id ${data.aws_secretsmanager_secret.redshift_password.name} --tags '[{\"Key\": \"AmazonDataZoneDomain\", \"Value\": \"${var.datazone_domain_id}\"}, {\"Key\": \"AmazonDataZoneProject\", \"Value\": \"${var.datazone_project_id}\"}, {\"Key\": \"datazone.rs.cluster\", \"Value\": \"${module.redshift.cluster_identifier}:${module.redshift.cluster_database_name}\"}]' --region ${var.region}"
  }

}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  redshift_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  # Use subnet group created by module
  create_redshift_subnet_group = false

  tags = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/redshift"
  version = "~> 5.0"

  name        = local.name
  description = "Redshift security group"
  vpc_id      = module.vpc.vpc_id

  # Allow ingress rules to be accessed only within current VPC
  ingress_rules       = ["redshift-tcp"]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

  # Allow all rules for all protocols
  egress_rules = ["all-all"]

  tags = local.tags
}

resource "aws_kms_key" "redshift" {
  description             = "Customer managed key for encrypting Redshift cluster"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = local.tags
}


resource "aws_redshift_subnet_group" "endpoint" {
  name       = "${local.name}-endpoint"
  subnet_ids = module.vpc.private_subnets

  tags = local.tags
}