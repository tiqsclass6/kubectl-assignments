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

- The first command adds the Prometheus Community repository.
- The second command refreshes metadata for all configured Helm repositories.

  ![helm-commands](/Screenshots/helm-commands.jpg)

## 🚀 Step 2: Install Monitoring Stack

```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace observability --create-namespace \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName="gp2" \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage="50Gi" \
  --set prometheus.service.type=LoadBalancer \
  --set grafana.service.type=LoadBalancer \
  --set grafana.persistence.enabled=true \
  --set grafana.persistence.storageClassName="gp2" \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName="gp2" \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage="10Gi"
```

- **Deploys**: Prometheus (metrics collection), Grafana (visualization), Alertmanager (alert handling), and Node Exporter (node metrics).
- **Storage**: Configures persistent storage with the `gp2` storage class:
  - Prometheus: 50 GiB volume.
  - Alertmanager: 10 GiB volume.
  - Grafana: Persistent storage enabled (default size unless overridden).
- **External Access**: Exposes Prometheus and Grafana via `LoadBalancer` Services for external access.
- **Namespace**: Creates and uses the `observability` namespace.

  ![helm-install](/Screenshots/helm-install.jpg)

## 🔍 Step 3: Verify Resources

Check the status of the deployed resources in the `observability` namespace.

### Pods

List pods associated with the `monitoring` Helm release:

```bash
kubectl --namespace observability get pods -l "release=monitoring"
```

- Displays pod names, status (e.g., `Running`, `Pending`), restarts, age, and other details for components like Prometheus, Grafana, Alertmanager, and Node Exporter.

  ![kubectl-release-monitoring](/Screenshots/kubectl-release-monitoring.jpg)

### StatefulSets

List StatefulSets for stateful components (Prometheus and Alertmanager):

```bash
kubectl get sts -n observability
```

- Shows names, ready replicas (e.g., `1/1`), and age of StatefulSets managing Prometheus and Alertmanager with persistent storage.

  ![kubectl-sts-observability](/Screenshots/kubectl-sts-observability.jpg)

### DaemonSets

List DaemonSets for node-level metrics collection:

```bash
kubectl get ds -n observability
```

- Displays the Prometheus Node Exporter DaemonSet, showing desired, current, up-to-date, and available pod counts across all nodes, along with age.

  ![kubectl-ds-observability](/Screenshots/kubectl-ds-observability.jpg)

### Services

```bash
kubectl get svc -n observability
```

- Shows Service names, types (`ClusterIP` or `LoadBalancer`), cluster IPs, external IPs (for `LoadBalancer`), ports, and age.
- Prometheus and Grafana Services have external IPs for access; others (e.g., Alertmanager, Node Exporter) use `ClusterIP` for internal communication.

  ![kubectl-svc-observability](/Screenshots/kubectl-svc-observability.jpg)

## 🌐 Step 4: Access UIs

Retrieve credentials and URLs to access the Grafana and Prometheus UIs.

### Get Grafana Admin Password

Get the Grafana admin password:

```bash
kubectl --namespace observability get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```

- Outputs the plain-text password for the `admin` user (default username: `admin`, default password: `prom-operator` unless overridden).
- Use this to log into the Grafana UI.
  ![prometheus-password](/Screenshots/prometheus-password.jpg)

  ```plaintext
  Username: admin
  Password: prom-operator
  ```

### Grafana URL

Get the external URL for the Grafana dashboard:

```bash
echo "http://$(kubectl get svc monitoring-grafana -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):80"
```

- Outputs a URL (e.g., `/ros/external-hostname:80`) for accessing Grafana in a browser.

  ![grafana-dashboard-url](/Screenshots/grafana-dashboard-url.jpg)

### Prometheus URL

Get the external URL for the Prometheus server:

```bash
echo "http://$(kubectl get svc monitoring-kube-prometheus-prometheus -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):9090"
```

- Outputs a URL (e.g., `http://<external-hostname>:9090`) for accessing the Prometheus UI.

  ![prometheus-server-url](/Screenshots/prometheus-server-url.jpg)

### UI Screenshots

- **Grafana**: Use `http://<grafana-hostname>:80` with username `admin` and the retrieved password.
- **Prometheus**: Use `http://<prometheus-hostname>:9090` (no authentication by default).
- Ensure `LoadBalancer` Services are fully provisioned (check `kubectl get svc -n observability` for external IPs/hostnames).

- **Grafana Homepage:**
  ![grafana-homescreen](/Screenshots/grafana-homescreen.jpg)

- **Prometheus Homepage:**
  ![prometheus-homescreen](/Screenshots/prometheus-homescreen.jpg)

## 🧹 Step 5: Cleanup

### Uninstall Helm Release

Remove the monitoring stack and namespace when no longer needed.

```bash
helm uninstall monitoring -n observability
```

- Deletes all resources created by the `kube-prometheus-stack` chart (Pods, StatefulSets, DaemonSets, Services, Secrets, ConfigMaps, PVCs).
- Persistent Volumes (PVs) may persist if the `gp2` storage class has a `Retain` reclaim policy. Manually delete PVCs (`kubectl delete pvc -n observability -l "release=monitoring"`) if needed.

### Delete Namespace

Remove the `observability` namespace:

```bash
kubectl delete namespace observability
```

- Deletes all remaining resources in the namespace, including any not removed by `helm uninstall`.
- PVs may persist if their reclaim policy is `Retain`. Check with `kubectl get pv` and delete manually if necessary (`kubectl delete pv <pv-name>`).

  ![helm-uninstall](/Screenshots/helm-uninstall-kubectl-delete.jpg)

---

## 🛠️ Troubleshooting

- **No Resources Found**: Verify the namespace (`kubectl get ns`) and Helm release (`helm list -n observability`).
- **Pending LoadBalancer**: Wait for the cloud provider to assign external IPs/hostnames (`kubectl get svc -n observability`).
- **Stuck Namespace Deletion**: Check for finalizers or stuck resources (`kubectl describe namespace observability`) and force deletion if needed (`kubectl delete namespace observability --force --grace-period=0`).
- **Persistent Volumes**: If PVs remain, verify the `gp2` storage class reclaim policy and manually delete unneeded PVs.

---

## 🔒 Security Notes

- **Grafana**: Change the default admin password after logging in to secure the dashboard.
- **Prometheus**: Add authentication or network policies for the `LoadBalancer` Service to restrict public access.
- **Secrets**: Avoid exposing the Grafana admin password in logs or public terminals.

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
