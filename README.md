# Kubernetes Assignment (05-31-2025)

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![EKS Cluster](https://img.shields.io/badge/EKS-Cluster-blue)
![Terraform](https://img.shields.io/badge/terraform-v1.6+-purple)
![License](https://img.shields.io/badge/license-MIT-green)

## 📦 Project Overview

This repository provides a complete, modular Terraform and Kubernetes setup for deploying an Amazon EKS cluster with proper VPC networking, IAM roles (including IRSA and Pod Identity support), and a series of example Kubernetes manifests. It is intended for DevOps learners and professionals who want a practical, end-to-end infrastructure-as-code (IaC) and container orchestration deployment experience.

---

## 📁 Project Structure

```text
.
├── 0-var.tf                       # Terraform variables
├── 1-auth.tf                      # AWS provider and auth config
├── 2-vpc.tf                       # VPC definition
├── 3-subnets.tf                   # Subnet definitions
├── 4-igw.tf                       # Internet Gateway
├── 5-nat.tf                       # NAT Gateway setup
├── 6-rtb.tf                       # Route Tables
├── 7-eks.tf                       # EKS Cluster definition
├── 8-node.tf                      # EKS Node Group setup
├── 9-iam-oidc.tf                  # IAM OIDC and associated policies
├── 10-iam-test.tf                 # IAM test roles and policy outputs
├── 11-runtime.tf                  # Data resources and output variables
├── .terraform/                    # Terraform provider plugin directory
├── .gitignore                     # Git ignored files
├── 1-beron-demo/                  # Sample Kubernetes manifests
│   ├── basic-deployment.yaml
│   ├── basic-pod.yaml
│   ├── basic-service.yaml
│   └── README.md
├── 2-irsa-demo/                   # IRSA and Pod Identity config
│   ├── sa.yaml                    # SA with IAM role annotation
│   ├── pod.yaml                   # Sample pod using the ServiceAccount
│   └── notes.md                   # Setup notes and comments
└── README.md                      
```

---

## 🚀 Deployment Instructions

1. **Initialize Terraform:**

   ```bash
   terraform init
   ```

2. **Format, Validate, and Preview the Deployment plan:**

   ```bash
   terraform fmt
   terraform validate
   terraform plan
   ```

3. **Apply infrastructure:**

   ```bash
   terraform apply
   ```

4. **Deploy example workloads:**

   ```bash  
   # Create a namespace
   kubectl create ns my-first-ns
   
   # Create a service account
   kubectl create sa -n my-first-ns my-app-id
   
   # Deploy your first pod
   kubectl apply -f basic-pod.yaml
   
   # Deploy your first deployment
   kubectl apply -f basic-deployment.yaml
   
   # Deploy your first service
   kubectl apply -f basic-service.yaml

   # View your active services to access your application
   kubectl get svc -n my-first-ns 
   ```

---

## 🔥 Teardown Instructions

To clean up all the EKS resources and associated infrastructure:

1. **Delete Kubernetes Resources:**

   ```bash
   kubectl delete -f 1-beron-demo/
   # NOTE: You must delete all the YAML files to properly delete the load balancer
   ```

2. **Destroy Terraform Infrastructure:**

   ```bash
   terraform destroy
   ```

---

## 🛠️ Troubleshooting Guide

| Issue | Resolution |
|-------|------------|
| `Error: unauthorized` | Check that your IAM user has sufficient permissions and is using the correct AWS profile. |
| `kubectl timeout` | Ensure the node group is active and that `aws eks update-kubeconfig` has been run correctly. |
| `Terraform plan changes desired_capacity` | Set `ignore_changes` on ASG desired_capacity in node group config to avoid this. |
| `Pod fails to assume IAM role` | Ensure IRSA annotations on the service account are correctly mapped with the IAM role ARN. |

---

## ✅ Best Practices Applied

- Modular Terraform layout
- AWS IAM Role for Service Account (IRSA) support
- AWS VPC with NAT Gateway, IGW, Route Tables
- EKS Cluster + managed Node Groups
- Kubernetes manifests for Pod, Deployment, and Service
- Proper `.gitignore` and lockfile for reproducibility

---

## 🤝 Contributing

Pull requests are welcome! Please fork the repository and use a feature branch. For major changes, open an issue first to discuss what you would like to change.

---
