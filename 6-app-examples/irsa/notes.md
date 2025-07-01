1) kubectl cluster-info

2) ensure files 10 and 11 are uncommented

3) examine sa.yaml 
   - copy output from:
     annotations:
       eks.amazonaws.com/role-arn: <HERE>

4) kubectl apply -f irsa-demo/sa.yaml
   OR
   kubectl create serviceaccount aws-test 
   kubectl annotate serviceaccount aws-test eks.amazonaws.com/role-arn=<ROLE ARN> 

   kubectl get sa

5) kubectl apply -f irsa-demo/pod.yaml

6) kubectl get pod
   kubectl describe pod/s3-test

wait 30 seconds

7) kubectl logs s3-test --tail=10
   OR
   kubectl logs s3-test | tail -n 10

8) verify that your token was retrived and buckets were listed

