kubectl delete -f config-server-service.yaml	
kubectl delete -f config-server-deployment.yaml	
kubectl delete -f discovery-server-deployment.yaml	
kubectl delete -f discovery-server-service.yaml	
kubectl delete -f customers-service-deployment.yaml	
kubectl delete -f customers-service-service.yaml		
kubectl delete -f vets-service-deployment.yaml
kubectl delete -f vets-service-service.yaml		
kubectl delete -f visits-service-deployment.yaml
kubectl delete -f visits-service-service.yaml	
kubectl delete -f api-gateway-service.yaml	
kubectl delete -f api-gateway-deployment.yaml		
kubectl delete -f tracing-server-service.yaml
kubectl delete -f tracing-server-deployment.yaml
kubectl delete -f admin-server-deployment.yaml	
kubectl delete -f admin-server-service.yaml		

kubectl get deployment,svc,pods,pvc

