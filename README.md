# Kubernetes Assignment (06-07-2025)

![Terraform](https://img.shields.io/badge/terraform-v1.6+-blueviolet)
![EKS](https://img.shields.io/badge/EKS-AWS--Managed--Kubernetes-orange)
![Status](https://img.shields.io/badge/deployment-success-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## 📦 Project Overview

This project showcases a complete Infrastructure-as-Code (IaC) solution to deploy a secure and production-ready Amazon EKS cluster using Terraform. It includes networking, IAM roles, Kubernetes manifests, Prometheus monitoring, storage provisioning, and Helm-based deployments.

---

## 📁 Project Structure (Key Components)

```shell
.
├── Terraform Core Files
│   ├── 0-var.tf                    # Input variables
│   ├── 1-auth.tf                   # AWS provider and authentication
│   ├── 2-vpc.tf                    # VPC
│   ├── 3-subnets                   # Subnets
│   ├── 4-igw.tf                    # Internet Gateway
│   ├── 5-nat.tf                    # NAT Gateway
│   ├── 6-rtb.tf                    # Route tables
│   ├── 7-eks.tf                    # EKS cluster
│   ├── 8-node.tf                   # Node groups
│   ├── 9-runtime.tf                # Runtime configs
│   ├── 10-iam-oidc.tf              # OIDC provider config
│   ├── 11a-storage-iam.tf          # IAM roles for storage
│   ├── 11b-storage-helm.tf         # Helm release for EBS CSI driver
│   ├── 12-output.tf                # Outputs
│
├── Kubernetes YAML Examples
│   ├── A-namespaces/               # Namespace definitions
│   ├── B-service-accounts/         # ServiceAccount definitions
│   ├── 1-beron-demo/               # Basic pod/deploy/service examples
│   ├── 2-irsa-demo/                # IRSA pod and serviceAccount
│   ├── 3-anton-demo/               # RBAC (viewer/admin bindings)
│   ├── 4-storage-test/             # PVC and pod using storage
│   ├── 5-prometheus/                # Prometheus Helm values and ns
│
├── Screenshots/                    # Visual references
├── example.kubeconfig              # Sample kubeconfig file
└── README.md                       # This file
```

---

## 🧪 Deployment Steps

```bash
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply
```

---

## 🔍 Outputs (from `terraform output`)

```hcl
ebs_csi_iam_role_arn = "arn:aws:iam::866340886126:role/demo-ebs-csi-iam-role"
eks_cluster_info = {
  "arn" = "arn:aws:eks:us-east-1:866340886126:cluster/demo"
  "description" = "EKS cluster info"
  "endpoint" = "https://DD3C17664E65B7197654BC12D49E098C.gr7.us-east-1.eks.amazonaws.com"
  "id" = "demo"
  "name" = "demo"
}
eks_node_group_summary = "Node group 'demo-private-nodes' runs 2 instance(s) of type t3.small"
openid_connect_provider = {
  "arn" = "arn:aws:iam::866340886126:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/DD3C17664E65B7197654BC12D49E098C"
  "url" = "https://oidc.eks.us-east-1.amazonaws.com/id/DD3C17664E65B7197654BC12D49E098C"
}
```

### Apply Kubernetes manifests

```bash
kubectl apply -f A-namespaces/
kubectl apply -f B-service-accounts/
kubectl apply -f 1-beron-demo/
kubectl get svc -n my-first-ns
```

- **Beron Cluster**
![Beron Cluster](/Screenshots/beron-cluster.jpg)

---

### Helm: Deploy Prometheus

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistence.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"
```

### Output from above command

```groovy
$ helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistence.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"
Release "prometheus" does not exist. Installing it now.
NAME: prometheus
LAST DEPLOYED: Mon Jun  9 19:52:46 2025
NAMESPACE: prometheus
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
prometheus-server.prometheus.svc.cluster.local


Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")       
  kubectl --namespace prometheus port-forward $POD_NAME 9090


The Prometheus alertmanager can be accessed via port 9093 on the following DNS name from within your cluster:
prometheus-alertmanager.prometheus.svc.cluster.local


Get the Alertmanager URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=alertmanager,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")     
  kubectl --namespace prometheus port-forward $POD_NAME 9093
#################################################################################
######   WARNING: Pod Security Policy has been disabled by default since    #####
######            it deprecated after k8s 1.25+. use                        #####
######            (index .Values "prometheus-node-exporter" "rbac"          #####
###### .          "pspEnabled") with (index .Values                         #####
######            "prometheus-node-exporter" "rbac" "pspAnnotations")       #####
######            in case you still need it.                                #####
#################################################################################


The Prometheus PushGateway can be accessed via port 9091 on the following DNS name from within your cluster:
prometheus-prometheus-pushgateway.prometheus.svc.cluster.local


Get the PushGateway URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus-pushgateway,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace prometheus port-forward $POD_NAME 9091

For more information on running Prometheus, visit:
https://prometheus.io/
```

---

## 🔍 Outputs (from `Prometheus from Helm`)

```bash
export POD_NAME=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace prometheus port-forward $POD_NAME 9090
```

---

## 🛠️ Troubleshooting

| Issue | Fix |
|-------|-----|
| `terraform plan` forces `desired_capacity` | Use `ignore_changes` in the node group |
| `kubectl timeout` | Make sure kubeconfig is updated and nodes are Ready |
| `Pod cannot access IRSA role` | Check `sa.yaml` and OIDC provider ARN matches |
| `Helm Release failed` | Ensure namespace exists and Helm repo is added |

---

## 🔥 Teardown Instructions

```bash
kubectl delete -f 1-beron-demo/
kubectl delete -f A-namespaces/
kubectl delete -f B-service-accounts/
terraform destroy
```

---

## 📸 Screenshots - Show Your Work

- **Beron**
![Beron](/Screenshots/beron.jpg)
- **Prometheus**
![Prometheus](/Screenshots/prometheus.jpg)

---
