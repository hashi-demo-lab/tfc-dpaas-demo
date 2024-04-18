resource "aws_iam_role" "glue" {
  name = "AmazonDataZoneGlueManageAccessRole-${var.region}-${var.datazone_domain_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "datazone.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account
          }
          ArnEquals = {
            "aws:SourceArn" = "arn:aws:datazone:${var.region}:${var.aws_account}:domain/${var.datazone_domain_id}"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy" "glue" {
  name = "AmazonDataZoneGlueManageAccessRolePolicy"
}

resource "aws_iam_role_policy_attachment" "glue" {
  role       = aws_iam_role.glue.name
  policy_arn = data.aws_iam_policy.glue.arn
}


# create role for redshift with trust relationshop
resource "aws_iam_role" "redshift" {
  name = "AmazonDataZoneRedshiftAccess-${var.region}-${var.datazone_domain_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Sid": "RedshiftTrustPolicyStatement",
            "Effect": "Allow",
            "Principal": {
                "Service": "datazone.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "855831148133"
                },
                "ArnEquals": {
                    "aws:SourceArn": "arn:aws:datazone:us-east-1:855831148133:domain/dzd_b7gonunt1mnycn"
                }
            }
        }
    ]
  })
}

data "aws_iam_policy" "redshift_managed" {
  name = "AmazonDataZoneRedshiftManageAccessRolePolicy"
}

resource "aws_iam_role_policy_attachment" "redshift_managed" {
  role       = aws_iam_role.redshift.name
  policy_arn = data.aws_iam_policy.redshift_managed.arn
}

# to do redshift access policy  - customer managed policy - aws secrets manager
resource "aws_iam_policy" "redshift" {
  name        = "AmazonDataZoneRedshiftAccessPolicy-${var.datazone_domain_id}"
  description = "Policy to allow DataZone to manage Redshift resources"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Sid": "RedshiftSecretStatement",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "secretsmanager:ResourceTag/AmazonDataZoneDomain": "dzd_b7gonunt1mnycn"
                }
            }
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift" {
  role       = aws_iam_role.redshift.name
  policy_arn = aws_iam_policy.redshift.arn
}