echo "This job would take 13s at least. Be patient please."

kubectl apply -f config-server-service.yaml	
kubectl apply -f config-server-deployment.yaml	
sleep 3s
kubectl apply -f discovery-server-deployment.yaml	
kubectl apply -f discovery-server-service.yaml	
sleep 3s
kubectl apply -f customers-service-deployment.yaml	
kubectl apply -f customers-service-service.yaml		
sleep 1s
kubectl apply -f vets-service-deployment.yaml
kubectl apply -f vets-service-service.yaml		
sleep 1s
kubectl apply -f visits-service-deployment.yaml
kubectl apply -f visits-service-service.yaml	
sleep 1s
kubectl apply -f api-gateway-service.yaml	
kubectl apply -f api-gateway-deployment.yaml		
sleep 1s
kubectl apply -f tracing-server-service.yaml
kubectl apply -f tracing-server-deployment.yaml
sleep 1s
kubectl apply -f admin-server-deployment.yaml	
kubectl apply -f admin-server-service.yaml			

kubectl get deployment,svc,pods,pvc

