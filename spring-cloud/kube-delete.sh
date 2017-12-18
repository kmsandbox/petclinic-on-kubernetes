#!/usr/bin/env bash
 
kubectl delete -f yaml4kube-new/config-server-service.yaml	
kubectl delete -f yaml4kube-new/config-server-deployment.yaml	
kubectl delete -f yaml4kube-new/discovery-server-deployment.yaml	
kubectl delete -f yaml4kube-new/discovery-server-service.yaml	
kubectl delete -f yaml4kube-new/customers-service-deployment.yaml	
kubectl delete -f yaml4kube-new/customers-service-service.yaml		
kubectl delete -f yaml4kube-new/vets-service-deployment.yaml
kubectl delete -f yaml4kube-new/vets-service-service.yaml		
kubectl delete -f yaml4kube-new/visits-service-deployment.yaml
kubectl delete -f yaml4kube-new/visits-service-service.yaml	
kubectl delete -f yaml4kube-new/api-gateway-service.yaml	
kubectl delete -f yaml4kube-new/api-gateway-deployment.yaml		
kubectl delete -f yaml4kube-new/tracing-server-service.yaml
kubectl delete -f yaml4kube-new/tracing-server-deployment.yaml
kubectl delete -f yaml4kube-new/admin-server-deployment.yaml	
kubectl delete -f yaml4kube-new/admin-server-service.yaml		

kubectl get deployment,svc,pods,pvc

