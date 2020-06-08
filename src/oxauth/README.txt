Steps to set up configuration:

-  kubectl apply -f oxauth-volumes.yaml

* Ensure that the references in oxauth.yml to the domain [default: demoexample.gluu.org] match your domain stated in the generate.json file (located in config)

- export NGINX_IP=<IP> [default should be minikube ip]
- sh deploy-pod.sh
