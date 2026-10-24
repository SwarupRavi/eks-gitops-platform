variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "eks-gitops"
}

variable "cluster_name" {
  type    = string
  default = "eks-gitops"
}

variable "cluster_version" {
  description = "Check the EKS console for versions currently in standard support"
  type        = string
  default     = "1.34"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "github_repo" {
  description = "GitHub repo allowed to push images, in owner/name form, e.g. swarupravi/eks-gitops-platform"
  type        = string
}
