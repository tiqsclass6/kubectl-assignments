# 🧠 Kubernetes Assignment (06-28-2025)

![Helm Version](https://img.shields.io/badge/Helm-3.x-blue?logo=helm)
![Kubernetes Version](https://img.shields.io/badge/K8s-1.21%2B-green?logo=kubernetes)
![Terraform](https://img.shields.io/badge/Terraform-v1.5%2B-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Operational-brightgreen)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

This repository provides a quickstart guide for deploying **Prometheus** and **Grafana** using the `kube-prometheus-stack` Helm chart. It sets up full observability in your Kubernetes cluster with persistent storage and LoadBalancer services.

---

## 📁 Project Structure

```shell
kubernetes-assignment/
├── charts/         # (Optional) Custom or downloaded charts
├── manifests/      # (Optional) Additional YAML configs
├── scripts/        # Automation scripts (e.g., install.sh, cleanup.sh)
├── README.md       # This documentation
└── values.yaml     # Custom Helm values (if applicable)
```

---

## 🚀 Installation Steps

### 1. Add Helm Repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 2. Install Prometheus + Grafana Stack

```bash
helm install monitoring prometheus-community/kube-prometheus-stack  --namespace observability --create-namespace  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName="gp2"  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage="50Gi"  --set prometheus.service.type=LoadBalancer  --set grafana.service.type=LoadBalancer  --set grafana.persistence.enabled=true  --set grafana.persistence.storageClassName="gp2"  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName="gp2"  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage="10Gi"
```

---

## 🔑 Grafana Access

- **Username**: `admin`
- **Password**: `prom-operator`

To get the auto-generated password (if overwritten):

```bash
kubectl --namespace observability get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```

---

## 📊 Dashboard Access

```bash
echo "Grafana Dashboard: http://$(kubectl get svc monitoring-grafana -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):80"
echo "Prometheus Server: http://$(kubectl get svc monitoring-kube-prometheus-prometheus -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):9090"
```

Or port forward locally:

```bash
export POD_NAME=$(kubectl --namespace observability get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=monitoring" -o name)
kubectl --namespace observability port-forward $POD_NAME 3000
```

---

## 📌 Useful Commands

```bash
kubectl --namespace observability get pods -l "release=monitoring"
kubectl get sts -n observability
kubectl get ds -n observability
kubectl get svc -n observability
```

---

## 🧹 Cleanup

```bash
helm uninstall monitoring -n observability
kubectl delete namespace observability
```

---

## 🛠️ Troubleshooting

| Issue | Resolution |
|-------|------------|
| `LoadBalancer` IP is pending | Ensure your cluster supports external LoadBalancer (e.g., AWS, GCP, Azure). |
| PVCs not bound | Check if the `gp2` storage class exists: `kubectl get storageclass` |
| Grafana password unknown | Retrieve it using the secrets command above. |
| Services not accessible | Check firewall rules, network policies, and whether the services are correctly exposed. |

---

## ⚙️ Terraform Integration

If you're using Terraform to provision your Kubernetes infrastructure (e.g., EKS, GKE, AKS), you can manage your observability stack in tandem.

### 🔨 Terraform Build Steps

1. Initialize your working directory:

   ```bash
   terraform init -reconfigure
   ```

2. Preview your changes:

   ```bash
   terraform fmt
   terraform validate
   terraform plan
   ```

3. Apply the configuration to build infrastructure:

   ```bash
   terraform apply -auto-approve
   ```

### 💣 Terraform Destroy

To tear down all infrastructure created by Terraform:

```bash
terraform destroy -auto-approve
```

> Ensure you are in the correct working directory and your state is not shared with production infrastructure before executing `destroy`.

---

## ✍️ Authors & Acknowledgments

- **Author:** T.I.Q.S.
- **Group Leader:** John Sweeney

### 🙏 Inspiration

This project was built with inspiration, mentorship, and guidance from:

- Sensei **"Darth Malgus" Theo**
- Lord **Beron**
- Sir **Rob**
- Jedi Master **Derrick**

Their wisdom, vision, and unwavering discipline made this mission possible.

---
