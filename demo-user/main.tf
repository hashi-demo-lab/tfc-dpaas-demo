variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "domain_id" {
  type    = string
  default = "dzd_4v2eph5vf9k7mq"
}

variable "project_id" {
  type    = string
  default = "c92so9gc67a5gi"
}

variable "iam_role" {
  type    = string
  default = "arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer"
}

variable "revision" {
  default = "7"
}

resource "terraform_data" "aws" {
  input = var.revision

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
set -e
CREDENTIALS=(`aws sts assume-role-with-web-identity --role-arn arn:aws:iam::855831148133:role/tfc-tfc-demo-au-retail_data_plaform --role-session-name build-session --web-identity-token $(cat $HOME/tfc-aws-token) --duration-seconds 1000 \
  --query "[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]" \
  --output text`)

unset AWS_PROFILE
export AWS_DEFAULT_REGION=ap-southeast-2
export AWS_ACCESS_KEY_ID="$${CREDENTIALS[0]}"
export AWS_SECRET_ACCESS_KEY="$${CREDENTIALS[1]}"
export AWS_SESSION_TOKEN="$${CREDENTIALS[2]}"

aws datazone create-project-membership --domain-identifier ${var.domain_id} --designation PROJECT_OWNER --region ${var.region} --project-identifier ${var.project_id} --member '{"userIdentifier":"arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer"}' --output json
EOF
  }
}


