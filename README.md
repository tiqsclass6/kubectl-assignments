# ☸️ Kubernetes EKS Weekly Assignments (Summary)

![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-326CE5?logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform&logoColor=white)
![Last Commit](https://img.shields.io/github/last-commit/tiqsclass6/kubectl-assignments)
![Repo Size](https://img.shields.io/github/repo-size/tiqsclass6/kubectl-assignments)
![Status](https://img.shields.io/badge/Status-Complete-blue)

This repository contains modular Amazon EKS infrastructure deployments using **Terraform**, **kubectl**, and **Helm**. Each **branch** represents a specific assignment week that incrementally builds out Kubernetes concepts such as namespaces, RBAC, IAM Roles for Service Accounts (IRSA), persistent storage, observability with Prometheus, and more.

---

## 📌 Branch Breakdown

### 🔹 [`assignment-05312025`](https://github.com/tiqsclass6/kubectl-assignments/tree/assignment-05312025)

- **Focus**: Foundational AWS EKS infrastructure using Terraform.
- **Includes**:
  - Full EKS cluster setup: VPC, subnets, NAT, IGW, route tables, node group
  - IRSA role + OIDC integration for secure pod permissions
  - Sample deployments: `basic-deployment.yaml`, `basic-service.yaml`, `basic-pod.yaml`
  - Example outputs: EKS ARN, node group info, OIDC URL
  - Manual `kubectl apply` walkthrough

---

### 🔹 [`assignment-06072025`](https://github.com/tiqsclass6/kubectl-assignments/tree/assignment-06072025)

- **Focus**: Production-grade Kubernetes cluster with monitoring and persistent storage.
- **Includes**:
  - Helm-based deployment of Prometheus using `prometheus-community` repo
  - StorageClass + PVC demo with `storage-pod.yaml` and `pvc-test.yaml`
  - ClusterRole and ClusterRoleBinding RBAC demos via Anton’s viewer/admin examples
  - Full Prometheus service notes, port-forward instructions, and Helm values config
  - Logical file structure: Terraform provisioning, IRSA, RBAC, namespaces, service accounts, screenshots

---

## 🚀 Getting Started

```bash
git clone https://github.com/tiqsclass6/kubectl-assignments
cd kubectl-assignments
git checkout <branch-name>

terraform init -upgrade
terraform validate
terraform apply

kubectl apply -f A-namespaces/
kubectl apply -f B-service-accounts/
kubectl apply -f 1-beron-demo/
```

---

## 🔥 Teardown Instructions

```bash
kubectl delete -f 1-beron-demo/
kubectl delete -f A-namespaces/
kubectl delete -f B-service-accounts/

terraform destroy
```

---

## 🛠️ Tools Used

- **Terraform** – AWS EKS and infrastructure provisioning
- **Amazon EKS** – Elastic Kubernetes Service
- **Helm** – Prometheus chart deployment
- **kubectl** – Apply deployments, services, namespaces
- **IRSA** – IAM Roles for Service Accounts
- **Persistent Storage** – EBS CSI driver with StorageClass
- **RBAC** – Cluster roles and role bindings
- **Screenshots** – Visual evidence of EKS Prometheus dashboards

---

## 📬 Contact

- **Maintainer:** T.I.Q.S.
- **Repo:** [tiqsclass6/kubectl-assignments](https://github.com/tiqsclass6/kubectl-assignments)
