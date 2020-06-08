Steps to set up configuration:

-  kubectl apply -f oxtrust-volumes.yaml

* Ensure that the references in oxtrust.yml to the domain [default: demoexample.gluu.org] match your domain stated in the generate.json file (located in config)

- export NGINX_IP=<IP> [default should be minikube ip]
- sh deploy-pod.sh
