output "terraform_sg_id" {
  value = module.security.pub_sg_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}