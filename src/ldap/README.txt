Steps to set up configuration:

-  kubectl apply -f opendj-volumes.yaml
-  kubectl apply -f opendj-init.yaml

In 4.1 these steps simply initialize a LDAP Service (it takes a few minutes nonetheless). In order to populate this service with Gluu Schema, run:

- kubectl run     --image=gluufederation/persistence:4.1.1_02     persistence     --env="GLUU_CONFIG_ADAPTER=kubernetes"     --env="GLUU_SECRET_ADAPTER=kubernetes"     --env="GLUU_OXTRUST_CONFIG_GENERATION=false"     --env="GLUU_LDAP_URL=opendj:1636"     --env="GLUU_PASSPORT_ENABLED=true" --env="GLUU_PERSISTENCE_TYPE=ldap"

This command will populate the LDAP. It might be necessary to fork this repository to adjust to EOEPCA Needs
