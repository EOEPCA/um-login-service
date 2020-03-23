#!/bin/bash

# Check presence of environment variables
TRAVIS_BUILD_DIR="${TRAVIS_BUILD_DIR:-.}"

# Create the K8S environment
cd ${TRAVIS_BUILD_DIR}/terraform/test && terraform apply -input=false -auto-approve

# Various debug statements
debug=true

SERVICES="login-engine gluu"

if ($debug == "true"); then

    docker ps

    # View cluster (kubectl) config in ~/.kube/config
    kubectl config view
    kubectl get nodes
    kubectl get namespaces
    kubectl get pods --all-namespaces
    kubectl get deployments login-engine

    kubectl logs deployment/login-engine --all-containers=true
    kubectl logs deployment/gluu --all-containers=true
    kubectl get service login-engine -o json
    kubectl describe deployment login-engine
    
    for i in $SERVICES; do
    kubectl describe service  $i
    done


fi

echo Testing connectivity with the infrastructure
# local host machine's minikube VM IP
minikubeIP=$(kubectl cluster-info | sed 's/\r$//' | grep 'master' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]{1,4}')
echo "MiniKube Master IP is ${minikubeIP}"

echo Testing connectivity with the services
for i in $SERVICES; do
    ip=$(kubectl get svc  $i -o json | jq -r '.spec.clusterIP')
    port=$(kubectl get service  $i --output=jsonpath='{.spec.ports[0].port}')
    echo Cluster IP of $i is ${ip}:${port}

    # curl echoes both ports to check connectivity.  The second set echoes the server headers should report nginx and javalin
    curl http://${ip}:${port}/search | jq '.'
    curl -si http://${ip}:${port}/search
done


if ($debug == "true"); then
    kubectl logs deployment/gluu --all-containers=true
    kubectl logs deployment/login-engine --all-containers=true
    
    # Namespace: deployment
    kubectl describe deployments 
    kubectl describe services    
    kubectl describe jobs        

    # Debug Persistent Volumes, PV Claims and Storage Classes
    kubectl describe pv
    kubectl describe pvc 
    kubectl get storageclass
fi
