# Kubernetes (Prometheus + Grafana)

[![Kubernetes](https://img.shields.io/badge/Kubernetes-Production--Ready-blue?logo=kubernetes)](https://kubernetes.io)
[![Helm Chart](https://img.shields.io/badge/Helm-kube--prometheus--stack-blue?logo=helm)](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)
[![Grafana](https://img.shields.io/badge/Grafana-Dashboard-yellow?logo=grafana)](https://grafana.com/)
[![Prometheus](https://img.shields.io/badge/Prometheus-Metrics-orange?logo=prometheus)](https://prometheus.io)
[![Last Updated](https://img.shields.io/badge/Updated-June%2029%2C%202025-informational)](https://github.com/tiqsclass6/kubectl-assignments/tree/assignment-06072025)

This guide outlines the steps to deploy, manage, and remove a Kubernetes monitoring stack using the `kube-prometheus-stack` Helm chart in the `observability` namespace. It includes Helm setup, installation, access instructions, validation, and teardown.

---

## 📁 Project Structure

```shell
├── Terraform Core Files
│   ├── 0-var.tf
│   ├── 1-auth.tf
│   ├── 2-vpc.tf
│   ├── 3-subnets
│   ├── 4-igw.tf
│   ├── 5-nat.tf
│   ├── 6-rtb.tf
│   ├── 7-eks.tf
│   ├── 8-node.tf
│   ├── 9-runtime.tf
│   ├── 10-iam-oidc.tf
│   ├── 11a-storage-iam.tf
│   ├── 11b-storage-helm.tf
│   ├── 12-output.tf
│
├── Kubernetes YAML Examples
│   ├── A-namespaces/
│   ├── B-service-accounts/
│   ├── 1-beron-demo/
│   ├── 2-irsa-demo/
│   ├── 3-anton-demo/
│   ├── 4-storage-test/
│   ├── 5-prometheus/
│
├── Screenshots/
├── example.kubeconfig
├── README.md
└── DEPLOY.md
```

---

## ✅ Prerequisites

- A Kubernetes cluster (e.g., AWS EKS) with Helm and `kubectl` installed.
- The `gp2` storage class available.
- A cloud provider supporting `LoadBalancer`.

## ⬇️ Step 1: Add Helm Repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

![helm-commands](/Screenshots/helm-commands.jpg)

## 🚀 Step 2: Install Monitoring Stack

```bash
helm install monitoring prometheus-community/kube-prometheus-stack   --namespace observability --create-namespace   --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName="gp2"   --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage="50Gi"   --set prometheus.service.type=LoadBalancer   --set grafana.service.type=LoadBalancer   --set grafana.persistence.enabled=true   --set grafana.persistence.storageClassName="gp2"   --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName="gp2"   --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage="10Gi"
```

![helm-install](/Screenshots/helm-install.jpg)

## 🔍 Step 3: Verify Resources

### Pods

```bash
kubectl --namespace observability get pods -l "release=monitoring"
```

![kubectl-release-monitoring](/Screenshots/kubectl-release-monitoring.jpg)

### StatefulSets

```bash
kubectl get sts -n observability
```

![kubectl-sts-observability](/Screenshots/kubectl-sts-observability.jpg)

### DaemonSets

```bash
kubectl get ds -n observability
```

![kubectl-ds-observability](/Screenshots/kubectl-ds-observability.jpg)

### Services

```bash
kubectl get svc -n observability
```

![kubectl-svc-observability](/Screenshots/kubectl-svc-observability.jpg)

## 🌐 Step 4: Access UIs

### Get Grafana Admin Password

```bash
kubectl --namespace observability get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```

![prometheus-password](/Screenshots/prometheus-password.jpg)

### Grafana URL

```bash
echo "http://$(kubectl get svc monitoring-grafana -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):80"
```

![grafana-dashboard-url](/Screenshots/grafana-dashboard-url.jpg)

### Prometheus URL

```bash
echo "http://$(kubectl get svc monitoring-kube-prometheus-prometheus -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):9090"
```

![prometheus-server-url](/Screenshots/prometheus-server-url.jpg)

### UI Screenshots

- **Grafana:**
  ![grafana-homescreen](/Screenshots/grafana-homescreen.jpg)

- **Prometheus:**
  ![prometheus-homescreen](/Screenshots/prometheus-homescreen.jpg)

## 🧹 Step 5: Cleanup

### Uninstall Helm Release

```bash
helm uninstall monitoring -n observability
```

### Delete Namespace

```bash
kubectl delete namespace observability
```

![helm-uninstall](/Screenshots/helm-uninstall-kubectl-delete.jpg)

---

## 🛠️ Troubleshooting

- **No Resources Found**: Check namespace and Helm release.
- **Pending LoadBalancer**: Wait or check cloud provider.
- **Stuck Namespace**: Use `--force --grace-period=0`.
- **Leftover PVs**: Check and delete if needed.

---

## 🔒 Security Notes

- Change Grafana's default admin password.
- Secure Prometheus with auth or network policies.
- Never expose secrets in logs.

---

## ✍️ Authors & Acknowledgments

- **Author:** T.I.Q.S.
- **Group Leader:** John Sweeney

### 🙏 Inspiration

With guidance from:

- Sensei **"Darth Malgus" Theo**
- Mr **A-A-Ron**
- Sir **Rob**
- Jedi Master **Derrick**
- Lord **Beron**

---
