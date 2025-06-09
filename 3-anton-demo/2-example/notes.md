1) ensure you are using IAM user that created EKS cluster with terraform (likely default profile)
```bash 
aws eks update-kubeconfig \
    --region us-east-1 \
    --name demo
```
2) use terraform add manager IAM with example-2-add-manager.tf
```terraform apply```

3) get keys for manager IAM user


4) add manager profile to aws cli
```aws configure --profile manager ```

5) verify aws cli is using profile
```aws sts get-caller-identity --profile manager```

6) assume role create with terraform and verify creds
```bash
aws sts assume-role \
    --role-arn <SEE TERRAFORM OUTPUT> \
    --role-session-name manager-session \
    --profile manager
```

7) edit aws cli profile file manually 
```vim ~/.aws/config```

or 

```bash
cat <<EOF >> ~/.aws/config

[profile eks-admin]
role_arn = <ROLE ARN FROM TERRAFORM>
source_profile = manager
EOF
```

8) update kubeconfig with eks-admin profile temporary credentials from aws cli 
```bash 
aws eks update-kubeconfig \
    --region us-east-1 \
    --name demo \
    --profile eks-admin
```

9) Verify kubeconfig is updated
```kubectl config view --minify```

10) check IAM roles with kubectl
```bash
kubectl get pods
kubectl get nodes
kubectl auth can-i "*" "*"