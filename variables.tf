variable "aws_region" {
  description = "AWS region for the shared host and ECR repositories"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for the shared host"
  type        = string
  default     = "t4g.micro"
}

variable "apps" {
  description = "Apps hosted on the shared instance: name -> { github_repo, domain }"
  type = map(object({
    github_repo = string # "owner/repo", used for the OIDC trust condition
    domain      = string # public domain Caddy will terminate TLS for and proxy to this app
  }))
  default = {
    dash-ushh-displacement = {
      github_repo = "nicolepaul/dash-ushh-displacement"
      domain      = "hps.nicolepaul.io"
    }
  }
}

variable "app_port" {
  description = "Port each app container listens on internally"
  type        = number
  default     = 8050
}
