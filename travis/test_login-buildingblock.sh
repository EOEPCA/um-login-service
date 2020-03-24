#!/bin/bash -x

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -e

# Check presence of environment variables
TRAVIS_BUILD_DIR="${TRAVIS_BUILD_DIR:-.}"

# Create the K8S environment
cd ${TRAVIS_BUILD_DIR}/terraform/test && terraform apply -input=false -auto-approve

# Various debug statements
debug=true

SERVICES="login-engine gluu"

if ($debug == "true"); then


    # View cluster (kubectl) config in ~/.kube/config
    kubectl config view
    kubectl get nodes
    kubectl get namespaces
    kubectl get pods --all-namespaces
    # kubectl get deployments --namespace=deployment login-engine

    #kubectl logs --namespace=deployment deployment/login-engine --all-containers=true
    #kubectl logs --namespace=deployment deployment/gluu --all-containers=true

    #kubectl get service --namespace=deployment login-engine -o json
    #kubectl describe deployment --namespace=deployment login-engine
    
    for i in $SERVICES; do
    echo $i
    #kubectl describe service --namespace=deployment $i
    done


fi

echo Testing connectivity with the infrastructure
# local host machine's minikube VM IP
minikubeIP=$(kubectl cluster-info | sed 's/\r$//' | grep 'master' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]{1,4}')
echo "MiniKube Master IP is ${minikubeIP}"

echo Testing connectivity with the services
#for i in $SERVICES; do
#    ip=$(kubectl get svc --namespace=deployment $i -o json | jq -r '.spec.clusterIP')
#    port=$(kubectl get service --namespace=deployment $i --output=jsonpath='{.spec.ports[0].port}')
#    echo Cluster IP of $i is ${ip}:${port}

#    # curl echoes both ports to check connectivity.  The second set echoes the server headers should report nginx and javalin
#    curl http://${ip}:${port}/search | jq '.'
#    curl -si http://${ip}:${port}/search
#done


if ($debug == "true"); then
    #kubectl logs --namespace=deployment deployment/gluu --all-containers=true
    #kubectl logs --namespace=deployment deployment/login-engine --all-containers=true
    
    # Namespace: deployment
    kubectl describe deployments --namespace=deployment
    kubectl describe services    --namespace=deployment
    kubectl describe jobs        --namespace=deployment

    # Debug Persistent Volumes, PV Claims and Storage Classes
    kubectl describe pv
    kubectl describe pvc --namespace=deployment
    kubectl get storageclass
fi

docker ps