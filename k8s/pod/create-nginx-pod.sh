kubectl create -f nginx.yaml

kubectl get rc
kubectl get pods

kubectl create -f nginx-service.yaml
kubectl describe svc nginx-service