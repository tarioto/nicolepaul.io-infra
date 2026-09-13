output "instance_id" {
  value = aws_instance.web.id
}

output "elastic_ip" {
  description = "Point each app's DNS A record at this IP"
  value       = aws_eip.web.public_ip
}

output "ecr_repository_urls" {
  value = { for k, v in aws_ecr_repository.app : k => v.repository_url }
}

output "deploy_role_arns" {
  description = "Set as the AWS_DEPLOY_ROLE_ARN repo variable in each app's GitHub Actions"
  value       = { for k, v in aws_iam_role.deploy : k => v.arn }
}
