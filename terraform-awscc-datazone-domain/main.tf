data "aws_caller_identity" "current" {}

#Execution role to be attached to Datazone Domain, has to be 
resource "awscc_iam_role" "this" {
  path = "/service-role/"
  assume_role_policy_document = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "datazone.amazonaws.com"
        },
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : data.aws_caller_identity.current.account_id
          },
          "ForAllValues:StringLike" : {
            "aws:TagKeys" : "datazone*"
          }
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonDataZoneDomainExecutionRolePolicy"]
}

resource "awscc_datazone_domain" "this" {
  name                  = var.datazone_domain_name
  description           = var.datazone_description
  domain_execution_role = awscc_iam_role.this.arn
  tags                  = var.tags
  kms_key_identifier    = var.datazone_kms_key_identifier
  single_sign_on        = var.single_sign_on
}

# create AWS Datazone IAM
module "datazone_iam" {
  source = "github.com/hashi-demo-lab/tfc-dpaas-demo//terraform-aws-iam-datazone"

  datazone_domain_id = awscc_datazone_domain.this.id
  aws_account        = data.aws_caller_identity.current.account_id
  region             = var.region
}

resource "aws_s3_bucket" "datazone" {
  bucket_prefix = "datazone-${var.region}-"
}

resource "aws_s3_bucket_public_access_block" "datazone" {
  bucket = aws_s3_bucket.datazone.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "datazone" {
  bucket = aws_s3_bucket.datazone.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "datazone" {
  bucket = aws_s3_bucket.datazone.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "datazone" {
  bucket = aws_s3_bucket.datazone.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Enable Data Zone blueprints
resource "awscc_datazone_environment_blueprint_configuration" "this" {
  for_each = var.environment_blueprints

  domain_identifier                = awscc_datazone_domain.this.id
  enabled_regions                  = each.value.enabled_regions
  environment_blueprint_identifier = each.value.environment_blueprint_identifier
  manage_access_role_arn           = module.datazone_iam.datazone_access_arns[each.value.environment_blueprint_identifier]
  provisioning_role_arn            = module.datazone_iam.datazone_provisioning_role_arn
  regional_parameters = [
    {
      region = "${aws_s3_bucket.datazone.region}"
      parameters = {
      "S3Location" = "s3://${aws_s3_bucket.datazone.id}" }
  }]
}


resource "awscc_datazone_project" "this" {
  for_each = var.datazone_projects

  domain_identifier = awscc_datazone_domain.this.id
  name              = each.key
  description       = try(each.value.description)
  glossary_terms    = try(each.value.glossary_terms)
}



################################################################################################
# Due to separation of duties, the following resources below will be moved to a different module
# moved to terraform-aws-datazone-environments/main.tf

/* # create environment profiles(s)
resource "awscc_datazone_environment_profile" "this" {
  for_each = var.datazone_environment_profiles

  aws_account_id                   = each.value.aws_account_id
  aws_account_region               = each.value.region
  domain_identifier                = awscc_datazone_domain.this.id
  environment_blueprint_identifier = awscc_datazone_environment_blueprint_configuration.this[each.value.environment_blueprint_identifier].environment_blueprint_id
  name                             = each.key
  description                      = try(each.value.description)
  project_identifier               = awscc_datazone_project.this[each.value.project_name].project_id
  user_parameters                  = try(each.value.user_parameters)
}

resource "awscc_datazone_environment" "this" {
  for_each = var.datazone_environments

  domain_identifier              = awscc_datazone_domain.this.id
  environment_profile_identifier = awscc_datazone_environment_profile.this[each.value.environment_profile_identifier].environment_profile_id
  name                           = each.value.name
  project_identifier             = awscc_datazone_project.this[each.value.project_target].project_id
} */