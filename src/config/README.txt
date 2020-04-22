Steps to set up configuration:

-  kubectl apply -f config-roles.yaml
-  kubectl apply -f config-volumes.yaml

* Edit generate.json file with the desired parameters, the password must have uppercase and lowercase characteres and at least one number and one special character!

Generate configuration mapping:

- kubectl create cm config-cm --from-file=generate.json
- kubectl apply -f load-config.yaml
