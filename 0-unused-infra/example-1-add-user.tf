# resource "aws_iam_user" "developer" {
#   name = "developer"
# }

# resource "aws_iam_policy" "developer_eks" {
#   name = "AmazonEKSDeveloperPolicy"

#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "eks:DescribeCluster",
#                 "eks:ListClusters"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# POLICY
# }

# # attach policy to IAM user
# resource "aws_iam_user_policy_attachment" "developer_eks" {
#   user       = aws_iam_user.developer.name
#   policy_arn = aws_iam_policy.developer_eks.arn
# }

# # use EKS access config API to bind IAM User to cluster, referencing the RBAC group "my-viewer"
