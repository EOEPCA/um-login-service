#!/bin/bash -x

### CONFIGURATION VARIABLES
#GLUU_SECRET_ADAPTER="kubernetes"
#ADMIN_PW="admin_Abcd1234#"
#EMAIL="support@gluu.org"
DOMAIN="demoexample.gluu.org"
##ORG_NAME="Deimos"
#COUNTRY_CODE="PT"
#STATE="NA"
#CITY="Lisbon"
#GLUU_CONFIG_ADAPTER="kubernetes"
#LDAP_TYPE="opendj"

# Install minikube and kubectl
K8S_VER=v1.12.0
TF_VER=0.12.16
MINIKUBE_VER=v1.9.1

# Make root mounted as rshared to fix kube-dns issues.
sudo mount --make-rshared /

echo "##### Installing minikube version $MINIKUBE_VER and kubectl version $K8S_VER"
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VER}/minikube-linux-amd64 
chmod +x minikube 
sudo mv minikube /usr/local/bin/

echo "##### (Re)start Minikube cluster"
minikube delete
minikube start --mount-string='/data:/data' --bootstrapper=kubeadm --kubernetes-version=${K8S_VER} --extra-config=apiserver.authorization-mode=RBAC

# Fix the kubectl context, as it's often stale.
minikube update-context

# Wait for Kubernetes to be up and ready.
echo "##### Waiting for kubernetes cluster to be ready"
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1; done

kubectl cluster-info

sudo chmod o+r ${HOME}/.kube/config
sudo chmod -R o+r ${HOME}/.minikube/

echo "##### Installing Terraform version $TF_VER"
sudo apt-get install unzip
curl -sLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip
unzip /tmp/terraform.zip -d /tmp
chmod +x /tmp/terraform
sudo mv /tmp/terraform /usr/local/bin/
export PATH="~/bin:$PATH"

# Setup ubuntu firewall
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 22
sudo ufw allow 8081
sudo ufw allow 8080
sudo ufw allow 8082
sudo ufw allow 8084
sudo ufw allow 8085
sudo ufw allow 8086
   
# Setup /etc/hosts
echo "Applying following entry to /etc/hosts"
echo "$(minikube ip)      $DOMAIN" | sudo tee -a /etc/hosts

# Apply config
echo "Applying config..."
kubectl apply -f ../src/config/config-roles.yaml
kubectl apply -f ../src/config/config-volumes.yaml
kubectl create cm config-cm --from-file=../src/config/generate.json
kubectl apply -f ../src/config/load-config.yaml

echo "##### Waiting for config pod to complete (will take around 5 minutes):"
until kubectl get pods | grep "config-init" | grep "Completed"; do sleep 1; done
echo "Done!"

# Apply LDAP
echo "Applying LDAP..."
kubectl apply -f ../src/ldap/opendj-volumes.yaml
kubectl apply -f ../src/ldap/opendj-init.yaml
# Populate LDAP
echo "Waiting..."
until kubectl logs opendj-init-0 | grep "Started listening for new connections on LDAPS Connection Handler"; do sleep 1; done
kubectl apply -f ../src/ldap/persistence.yaml
until kubectl get pods | grep "persistence" | grep "Completed"; do sleep 1; done

#echo "##### Waiting for LDAP to start (will take around 10 minutes, ContainerCreating errors are expected):"
#sleep 20
echo "Done!"

# Enable Ingress
minikube addons enable ingress
sh ../src/nginx/tls-secrets.sh
kubectl apply -f ../src/nginx/nginx.yaml

# Apply oxAuth
echo "Applying oxAuth"
kubectl apply -f ../src/oxauth/oxauth-volumes.yaml
#mkdir -p /data/oxauth/custom
#cp -rp ../src/oxauth/custom/pages /data/oxauth/custom/
cat ../src/oxauth/oxauth.yaml | sed "s/{{GLUU_DOMAIN}}/$DOMAIN/g" | sed -s "s@NGINX_IP@$(minikube ip)@g" | kubectl apply -f -
echo "##### Waiting for oxAuth to start (will take around 5 minutes, ContainerCreating errors are expected):"
#counter=0
#until [ `kubectl logs service/oxauth | grep "Server:main: Started" | wc -l` -ge 1 ] || [ $counter -gt 6 ]; do ((counter++)); sleep 15; done
echo "Done!"

# Apply oxTrust
echo "Applying oxTrust"
kubectl apply -f ../src/oxtrust/oxtrust-volumes.yaml
cat ../src/oxtrust/oxtrust.yaml | sed "s/{{GLUU_DOMAIN}}/$DOMAIN/g" | sed -s "s@NGINX_IP@$(minikube ip)@g" | kubectl apply -f -
echo "##### Waiting for oxTrust to start (will take around 5 minutes, ContainerCreating errors are expected):"
#counter=0
#until [ `kubectl logs service/oxtrust | grep "Server:main: Started" | wc -l` -ge 1 ] || [ $counter -gt 6 ]; do ((counter++)); sleep 15; done
echo "Done!"

# Apply Passport
echo "Applying Passport"
cat ../src/oxpassport/oxpassport.yaml | sed "s/{{GLUU_DOMAIN}}/$DOMAIN/g" | sed -s "s@NGINX_IP@$(minikube ip)@g" | kubectl apply -f -
echo "Done!"