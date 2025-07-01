# resource "helm_release" "prometheus" {
#     depends_on = [aws_eks_node_group.private-nodes, null_resource.update_kubeconfig, helm_release.ebs_csi_driver ]
#   name             = "prometheus"
#   namespace        = "prometheus"
#   create_namespace = true
#   chart = "prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   version = "27.20.0"
#   values = [
#     file("${path.module}/prometheus-1/values.yaml")
#   ]
# }