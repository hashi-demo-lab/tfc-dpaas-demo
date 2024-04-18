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


# create role for redshift with inline policy AmazonDataZoneRedshiftAccess-<region>-<domainId> use assume
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

data "aws_iam_policy" "redshift" {
  name = "AmazonDataZoneRedshiftManageAccessRolePolicy"
}

resource "aws_iam_role_policy_attachment" "redshift" {
  role       = aws_iam_role.redshift.name
  policy_arn = data.aws_iam_policy.redshift.arn
}