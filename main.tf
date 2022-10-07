# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
}

module "security" {
  source = "./modules/security"
}