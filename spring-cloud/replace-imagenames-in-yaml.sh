#!/usr/bin/env bash
  
# change the namespace of images from 'mszarlinski' to 'default'
cp -rf yaml4kube yaml4kube-new 
cd yaml4kube-new
echo "sed -i 's/mszarlinski/stdcluster.icp:8500\/default/g' *deployment.yaml"
echo
mkdir replaced
sed 's=mszarlinski=stdcluster.icp:8500/default=g' < config-server-deployment.yaml	> replaced/config-server-deployment.yaml	
sed 's=mszarlinski=stdcluster.icp:8500/default=g' < discovery-server-deployment.yaml	> replaced/discovery-server-deployment.yaml	
sed 's=mszarlinski=stdcluster.icp:8500/default=g' < customers-service-deployment.yaml	> replaced/customers-service-deployment.yaml	
sed 's=mszarlinski=stdcluster.icp:8500/default=g' < vets-service-deployment.yaml > replaced/vets-service-deployment.yaml
sed 's=mszarlinski=stdcluster.icp:8500/default=g' < visits-service-deployment.yaml > replaced/visits-service-deployment.yaml
sed 's=mszarlinski=stdcluster.icp:8500/default=g' < api-gateway-deployment.yaml > replaced/api-gateway-deployment.yaml		
sed 's=mszarlinski=stdcluster.icp:8500/default=g' < tracing-server-deployment.yaml > replaced/tracing-server-deployment.yaml
sed 's=mszarlinski=stdcluster.icp:8500/default=g' < admin-server-deployment.yaml > replaced/admin-server-deployment.yaml
cp replaced/* .
rm -rf replaced

echo "current path: "
pwd
echo ""
ls
echo ""
echo ""
cat customers-service-deployment.yaml
echo ""
cat customers-service-service.yaml
