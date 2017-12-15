#!/usr/bin/env bash
 
echo "This job would take 30s at least. Be patient please."

kubectl apply -f yaml4kube-new/config-server-service.yaml	
kubectl apply -f yaml4kube-new/config-server-deployment.yaml	
sleep 10s
kubectl apply -f yaml4kube-new/discovery-server-deployment.yaml	
kubectl apply -f yaml4kube-new/discovery-server-service.yaml	
sleep 10s
kubectl apply -f yaml4kube-new/customers-service-deployment.yaml	
kubectl apply -f yaml4kube-new/customers-service-service.yaml		
sleep 3s
kubectl apply -f yaml4kube-new/vets-service-deployment.yaml
kubectl apply -f yaml4kube-new/vets-service-service.yaml		
sleep 3s
kubectl apply -f yaml4kube-new/visits-service-deployment.yaml
kubectl apply -f yaml4kube-new/visits-service-service.yaml	
sleep 3s
kubectl apply -f yaml4kube-new/api-gateway-service.yaml	
kubectl apply -f yaml4kube-new/api-gateway-deployment.yaml		
sleep 3s
kubectl apply -f yaml4kube-new/tracing-server-service.yaml
kubectl apply -f yaml4kube-new/tracing-server-deployment.yaml
sleep 3s
kubectl apply -f yaml4kube-new/admin-server-deployment.yaml	
kubectl apply -f yaml4kube-new/admin-server-service.yaml			

kubectl get deployment,svc,pods,pvc

