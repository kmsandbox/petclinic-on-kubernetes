# change the namespace of images from 'mszarlinski' to 'default'
cp -rf yaml4kube yaml4kube-new 
cd yaml4kube-new
echo "sed -i 's/mszarlinski/stdcluster.icp:8500\/default/g' *deployment.yaml"
echo
sed -i 's/mszarlinski/default/g' *deployment.yaml
echo "current path: "
pwd
echo ""
ls
echo ""
cat conf*deploy*yaml
