# EKS GitOps Platform

A secure delivery pipeline on AWS: code is built, scanned and deployed to EKS automatically, and monitored with Prometheus and Grafana.

```
push to main → GitHub Actions (build → Trivy scan → SBOM → push to ECR)
             → commits new image tag to charts/app/values.yaml
             → ArgoCD syncs the Helm chart to EKS
             → Prometheus + Grafana monitor cluster and app
```

## Stack
- **Infrastructure:** Terraform (VPC, EKS, ECR, IAM), remote state in S3 with native locking
- **CI:** GitHub Actions, Trivy, SBOM (SPDX), OIDC auth to AWS (no stored keys)
- **CD:** Helm, ArgoCD (GitOps, auto-sync, self-heal)
- **Monitoring:** kube-prometheus-stack (Prometheus, Grafana, Alertmanager)
- **Security:** least-privilege IAM, immutable + scanned ECR images, distroless non-root container, read-only root filesystem

## Setup
1. **State bucket:** `cd terraform/bootstrap && terraform init && terraform apply -var state_bucket_name=<unique-name>`
2. **Infrastructure:** update the bucket in `terraform/backend.tf`, copy `terraform.tfvars.example` to `terraform.tfvars`, then
   `cd terraform && terraform init && terraform apply`
3. **kubectl:** run the `configure_kubectl` output command
4. **GitHub secret:** add `github_actions_role_arn` output as repo secret `AWS_ROLE_ARN`
5. **ArgoCD:**
   `kubectl create namespace argocd`
   `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`
   `kubectl apply -f argocd/application.yaml`
6. **Monitoring:**
   `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`
   `helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace`
7. **Deploy:** push a change under `app/` to main and watch ArgoCD roll it out

## Teardown (do this daily to save cost)
`cd terraform && terraform destroy`

## Screenshots
_Add: pipeline run, Trivy results, ArgoCD app view, Grafana dashboard._
