provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Elastic Container Repositories for Docker images
resource "aws_ecr_repository" "nginx_container_repository" {
  name = "${var.application_name}-nginx"
}
resource "aws_ecr_repository" "api_container_repository" {
  name = "${var.application_name}-api"
}
resource "aws_ecr_repository" "client_container_repository" {
  name = "${var.application_name}-client"
}

# Elastic Beanstalk app
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = var.application_name
  description = "Elastic beanstalk app for our multi-container configuration"
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "eb_env" {
  name                = "${var.application_name}-env"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.22.1 running Multi-container Docker 19.03.6-ce (Generic)"
  tier                = "WebServer"

  # use the default instance profile for now
  setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = "aws-elasticbeanstalk-ec2-role"
  }
}

# CodeBuild and CodePipeline CI/CD
module "build" {
    source              = "git::https://github.com/cloudposse/terraform-aws-cicd.git?ref=tags/0.10.2"
    stage               = "prod"
    name                = var.application_name

    # Enable the pipeline creation
    enabled             = true

    # Elastic Beanstalk
    elastic_beanstalk_application_name = aws_elastic_beanstalk_application.eb_app.name
    elastic_beanstalk_environment_name = aws_elastic_beanstalk_environment.eb_env.name

    # Application repository on GitHub
    github_oauth_token  = var.github_oauth_token
    repo_owner          = var.github_username
    repo_name           = var.github_repo_name
    branch              = "master"

    # http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html
    # http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html
    build_image         = "aws/codebuild/standard:4.0"
    build_compute_type  = "BUILD_GENERAL1_SMALL"

    force_destroy = true

    # These attributes are optional, used as ENV variables when building Docker images and pushing them to ECR
    # For more info:
    # http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html
    # https://www.terraform.io/docs/providers/aws/r/codebuild_project.html
    privileged_mode     = true
    region              = var.aws_region
    aws_account_id      = var.aws_account_id

}
