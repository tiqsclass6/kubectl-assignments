# IRSA Demo Instructions

## 1. Check Cluster Info

```bash
kubectl cluster-info
```

## 2. Ensure Files Are Uncommented

- Make sure that lines 10 and 11 in the relevant configuration files are **uncommented**.

## 3. Examine `sa.yaml`

- Locate the following section:

  ```yaml
  annotations:
    eks.amazonaws.com/role-arn: <HERE>
  ```

- Copy the `<HERE>` value with your actual IAM role ARN.

## 4. Create or Apply the Service Account

You can **either** apply the predefined YAML file:

```bash
kubectl apply -f irsa-demo/sa.yaml
```

**OR** manually create and annotate the service account:

```bash
kubectl create serviceaccount aws-test
kubectl annotate serviceaccount aws-test eks.amazonaws.com/role-arn=<ROLE ARN>
```

Verify that the service account was created:

```bash
kubectl get sa
```

## 5. Deploy the Pod

```bash
kubectl apply -f irsa-demo/pod.yaml
```

## 6. Verify Pod Status

```bash
kubectl get pod
kubectl describe pod/s3-test
```

Wait **30 seconds** for the pod to initialize.

## 7. Check Pod Logs

```bash
kubectl logs s3-test --tail=10
# OR
kubectl logs s3-test | tail -n 10
```

## 8. Validate Output

- Confirm that the IAM **token was retrieved**.
- Ensure that **S3 buckets were listed** successfully in the logs.
