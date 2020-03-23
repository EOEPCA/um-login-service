#!/bin/bash

# Check presence of environment variables
TRAVIS_BUILD_DIR="${TRAVIS_BUILD_DIR:-.}"

# Create the K8S environment
cd ${TRAVIS_BUILD_DIR}/terraform/test && terraform apply -input=false -auto-approve #-var='db_username=$DB_USER' -var='db_password=$DB_PASSWORD' 

# Various debug statements
debug=false

SERVICES="user-login-engine user-common-gluu"

if ($debug == "true"); then

    # View cluster (kubectl) config in ~/.kube/config
    kubectl config view
    kubectl get nodes
    kubectl get secret db-user-pass -o yaml --namespace=eo-services
    kubectl get namespaces
    kubectl get pods --all-namespaces
    kubectl get deployments --namespace=eo-services user-login-engine-deployment

    kubectl logs --namespace=eo-services deployment/user-login-engine-deployment --all-containers=true
    kubectl logs --namespace=eo-services deployment/user-common-gluu --all-containers=true
    kubectl get service --namespace=eo-services user-login-engine -o json
    kubectl describe deployment --namespace=eo-services user-login-engine-deployment
    
    for i in $SERVICES; do
    kubectl describe service --namespace=eo-services $i
    done


fi

echo Testing connectivity with the infrastructure
# local host machine's minikube VM IP
minikubeIP=$(kubectl cluster-info | sed 's/\r$//' | grep 'master' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]{1,4}')
echo "MiniKube Master IP is ${minikubeIP}"

echo Testing connectivity with the services
for i in $SERVICES; do
    ip=$(kubectl get svc --namespace=eo-services $i -o json | jq -r '.spec.clusterIP')
    port=$(kubectl get service --namespace=eo-services $i --output=jsonpath='{.spec.ports[0].port}')
    echo Cluster IP of $i is ${ip}:${port}

    # curl echoes both ports to check connectivity.  The second set echoes the server headers should report nginx and javalin
    curl http://${ip}:${port}/search | jq '.'
    curl -si http://${ip}:${port}/search
done


if ($debug == "true"); then
    kubectl logs --namespace=eo-services deployment/user-common-gluu --all-containers=true
    kubectl logs --namespace=eo-services deployment/user-login-engine-deployment --all-containers=true
    
    # Namespace: eo-services
    kubectl describe deployments --namespace=eo-services
    kubectl describe services    --namespace=eo-services
    kubectl describe jobs        --namespace=eo-services

    # Namespace: eo-user-compute
    kubectl describe deployments --namespace=eo-user-compute
    kubectl describe services    --namespace=eo-user-compute
    kubectl describe jobs        --namespace=eo-user-compute
    kubectl describe quota --namespace=eo-user-compute

    # Debug Persistent Volumes, PV Claims and Storage Classes
    kubectl describe pv
    kubectl describe pvc --namespace=eo-user-compute
    kubectl get storageclass
fi
