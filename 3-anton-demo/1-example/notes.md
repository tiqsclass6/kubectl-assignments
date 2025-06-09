1) apply RBAC group and RoleBinding
```kubectl apply -f putra/1-example```

2) Uncomment and apply example-1-add-user.tf
terraform apply 

3) add security key to developer IAM user in console

4) add developer profile to aws cli
```aws configure --profile developer ```

5) verify aws cli is using profile
```aws sts get-caller-identity --profile developer```

6) update kubeconfig with developer credentials from aws cli 
```bash 
aws eks update-kubeconfig \
    --region us-east-1 \
    --name demo \
    --profile developer```

7) Verify kubeconfig is updated
```kubectl config view --minify```

8) verify cluster access
```kubectl cluster-info```
```kubectl get pods```
```kubectl auth can-i get pods```

9) verify node access is not permitted
```kubectl get nodes```
```kubectl auth can-i get nodes```

10) switch to admin
```bash
aws eks update-kubeconfig \
    --region us-east-1 \
    --name demo
```
