kubectl apply -f config-server-service.yaml	
kubectl apply -f config-server-deployment.yaml	
kubectl apply -f discovery-server-deployment.yaml	
kubectl apply -f discovery-server-service.yaml	
kubectl apply -f customers-service-deployment.yaml	
kubectl apply -f customers-service-service.yaml		
kubectl apply -f vets-service-deployment.yaml
kubectl apply -f vets-service-service.yaml		
kubectl apply -f visits-service-deployment.yaml
kubectl apply -f visits-service-service.yaml	
kubectl apply -f api-gateway-service.yaml	
kubectl apply -f api-gateway-deployment.yaml		
kubectl apply -f tracing-server-service.yaml
kubectl apply -f tracing-server-deployment.yaml
kubectl apply -f admin-server-deployment.yaml	
kubectl apply -f admin-server-service.yaml			

kubectl get deployment,svc,pods,pvc

