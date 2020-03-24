#!/bin/bash -x

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -e

# Check presence of environment variables
TRAVIS_BUILD_DIR="${TRAVIS_BUILD_DIR:-.}"

# Create the K8S environment
cd ${TRAVIS_BUILD_DIR}/terraform/test && terraform apply -input=false -auto-approve

# Various debug statements
debug=true

if ($debug == "true"); then
    # View cluster (kubectl) config in ~/.kube/config
    kubectl config view
    kubectl get nodes
    kubectl get namespaces
    kubectl get pods --all-namespaces
fi

echo Testing connectivity with the infrastructure
# local host machine's minikube VM IP
minikubeIP=$(kubectl cluster-info | sed 's/\r$//' | grep 'master' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]{1,4}')
echo "MiniKube Master IP is ${minikubeIP}"

echo Testing connectivity with the services

if ($debug == "true"); then
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