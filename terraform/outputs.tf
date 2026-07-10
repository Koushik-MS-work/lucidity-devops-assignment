output "cluster_name" {
  description = "Name of the created EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for the cluster (used to authenticate)."
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "region" {
  description = "AWS region the cluster was deployed in."
  value       = var.aws_region
}

output "vpc_id" {
  description = "ID of the VPC created for the cluster."
  value       = module.vpc.vpc_id
}

output "configure_kubectl" {
  description = "Command to configure kubectl to talk to the new cluster."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
