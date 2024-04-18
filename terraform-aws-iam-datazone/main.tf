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
