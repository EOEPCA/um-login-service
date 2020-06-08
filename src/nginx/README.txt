Steps to set up configuration:

* Ensure that ingress.crt and ingress.key do not exist in this folder

-  minikube addons enable ingress
-  sh tls-secrets.sh
-  kubectl apply -f nginx.yaml

Ensure that your DNS will resolve the NGINX IP to the correct domain! (/etc/hosts used on dev env)
