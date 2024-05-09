resource "terraform_data" "aws" {

  provisioner "local-exec" {
    command = "aws sts assume-role-with-web-identity --role-arn arn:aws:iam::855831148133:role/tfc-tfc-demo-au-bu1_data_plaform1 --role-session-name build-session --web-identity-token $(cat $HOME/tfc-aws-token) --duration-seconds 1000; aws sts get-caller-identity"
  
    #"aws datazone create-project-membership --secret-id ${data.aws_secretsmanager_secret.redshift_password.name} --tags '[{\"Key\": \"AmazonDataZoneDomain\", \"Value\": \"${var.datazone_domain_id}\"}, {\"Key\": \"AmazonDataZoneProject\", \"Value\": \"${var.datazone_project_id}\"}, {\"Key\": \"datazone.rs.cluster\", \"Value\": \"${module.redshift.cluster_identifier}:${module.redshift.cluster_database_name}\"}]' --region ${var.region}"
  }

}

output "local_exec" {
  value = terraform_data.aws.output
}