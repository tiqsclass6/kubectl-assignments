# ☸️ Kubernetes EKS Weekly Assignments (Summary)

![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-326CE5?logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud%20Platform-FF9900?logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-Package%20Manager-0F1689?logo=helm&logoColor=white)
![Last Commit](https://img.shields.io/github/last-commit/tiqsclass6/kubectl-assignments)
![Repo Size](https://img.shields.io/github/repo-size/tiqsclass6/kubectl-assignments)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

---

This repository contains modular _Amazon EKS infrastructure_ deployments using **Terraform**, **kubectl**, and **Helm**. Each **branch** represents a specific assignment week that incrementally builds out Kubernetes concepts such as namespaces, RBAC, IAM Roles for Service Accounts (IRSA), persistent storage, observability with Prometheus, metrics with Grafana, and more.

![example1](/example1.png)
![example2](/example2.png)

---

## 📌 Branch Breakdown

### 🔹 [assignment-05312025](https://github.com/tiqsclass6/kubectl-assignments/tree/assignment-05312025)

![Branch](https://img.shields.io/badge/Branch-assignment--05312025-blue)
![Last Commit](https://img.shields.io/github/last-commit/tiqsclass6/kubectl-assignments/assignment-05312025)
![Build](https://img.shields.io/badge/Status-Building-success)

- **Focus**: Foundational AWS EKS infrastructure using Terraform.
- **Includes**:
  - Full EKS cluster setup: VPC, subnets, NAT, IGW, route tables, node group
  - IRSA role + OIDC integration for secure pod permissions
  - Sample deployments: `basic-deployment.yaml`, `basic-service.yaml`, `basic-pod.yaml`
  - Example outputs: EKS ARN, node group info, OIDC URL
  - Manual `kubectl apply` walkthrough

### 🔹 [assignment-06072025](https://github.com/tiqsclass6/kubectl-assignments/tree/assignment-06072025)

![Branch](https://img.shields.io/badge/Branch-assignment--06072025-purple)
![Last Commit](https://img.shields.io/github/last-commit/tiqsclass6/kubectl-assignments/assignment-06072025)
![Monitoring](https://img.shields.io/badge/Prometheus-Deployed-success)

- **Focus**: Production-grade Kubernetes cluster with monitoring and persistent storage.
- **Includes**:
  - Helm-based deployment of Prometheus using `prometheus-community` repo
  - StorageClass + PVC demo with `storage-pod.yaml` and `pvc-test.yaml`
  - ClusterRole and ClusterRoleBinding RBAC demos via Anton’s viewer/admin examples
  - Full Prometheus service notes, port-forward instructions, and Helm values config
  - Logical file structure: Terraform provisioning, IRSA, RBAC, namespaces, service accounts, screenshots

### 🔹 [assignment-06302025](https://github.com/tiqsclass6/kubectl-assignments/tree/assignment-06302025)

![Branch](https://img.shields.io/badge/Branch-assignment--06302025-orange)
![Last Commit](https://img.shields.io/github/last-commit/tiqsclass6/kubectl-assignments/assignment-06302025)
![Status](https://img.shields.io/badge/HPA-Enabled-brightgreen)

- **Focus**: Service-level monitoring, pod auto-scaling, and advanced Helm configuration.
- **Includes**:
  - Horizontal Pod Autoscaler (HPA) with CPU metrics
  - Custom metrics using Prometheus and Grafana
  - Helm upgrade/rollback demo for versioned deployments
  - Deep dive into `helm upgrade --install`, rollback strategies, and release history
  - Enhanced Terraform state management and Helm release tracking via `terraform-provider-helm`

---

## 🚀 Getting Started

```bash
git clone https://github.com/tiqsclass6/kubectl-assignments
cd kubectl-assignments
git checkout <branch-name>

terraform init -upgrade
terraform fmt
terraform validate
terraform apply -auto-approve

kubectl apply -f A-namespaces/
kubectl apply -f B-service-accounts/
```

---

## 🔥 Teardown Instructions

```bash
kubectl delete -f A-namespaces/
kubectl delete -f B-service-accounts/

terraform destroy -auto-approve
```

---

## 🛠️ Tools Used

- **Terraform** – AWS EKS and infrastructure provisioning
- **Amazon EKS** – Elastic Kubernetes Service
- **Helm** – Prometheus chart deployment, Helm upgrades/rollbacks
- **kubectl** – Apply deployments, services, namespaces
- **IRSA** – IAM Roles for Service Accounts
- **Persistent Storage** – EBS CSI driver with StorageClass
- **RBAC** – Cluster roles and role bindings
- **Metrics Server & HPA** – Auto-scaling based on real-time metrics
- **Prometheus Adapter** – Custom metrics collection
- **Screenshots** – Visual evidence of EKS dashboards and workloads

---

## 📬 Contact

- **Maintainer:** T.I.Q.S.
- **Repo:** [Kubectl-Assignments](https://github.com/tiqsclass6/kubectl-assignments)

---
