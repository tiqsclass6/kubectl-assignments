# # IRSA Config file (I think...)

# # Why do we need this? Stuff like:
# # 1) Give a Kubernetes pod access to S3, Secrets Manager, etc.
# # 2) Use tools like the AWS Load Balancer Controller (for Ingress), Cluster Autoscaler, etc.
# # 3) Securely grant IAM permissions without hardcoding credentials in your pods.


# # Fetch the TLS certificate from the OIDC issuer URL (provided by EKS)
# # this retrieves the public certificate used by EKS's OIDC provider to sign tokens.
# # It's needed to create a trusted relationship between AWS IAM and the Kubernetes OIDC provider.
# data "tls_certificate" "eks" {
#   url = aws_eks_cluster.demo.identity[0].oidc[0].issuer
# }

# # Create an IAM OIDC identity provider in your AWS account
# # This sets up a trusted identity provider in AWS IAM, pointing to your EKS cluster's OIDC provider.
# # client_id_list = ["sts.amazonaws.com"]: Only AWS STS can assume the role.
# # The thumbprint ensures AWS trusts tokens signed by the OIDC provider.
# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
#   url             = aws_eks_cluster.demo.identity[0].oidc[0].issuer
# }