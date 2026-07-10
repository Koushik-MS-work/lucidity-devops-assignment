variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix used for tagging and naming resources."
  type        = string
  default     = "lucidity-hello-world"
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "lucidity-hello-world-eks"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.29"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to spread subnets across."
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs (used for worker nodes)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs (used for the NAT gateway / load balancers)."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 4
}

variable "single_nat_gateway" {
  description = "Use a single shared NAT gateway instead of one per AZ (cheaper, less HA). Recommended true for this assignment/demo."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    Project   = "lucidity-devops-assignment"
    ManagedBy = "terraform"
  }
}
