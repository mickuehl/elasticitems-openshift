#!/bin/bash

CICD_PROJECT_NAME='cicd'
CICD_DISPLAY_NAME='infrastructure'
DOMAIN_NAME='svc.beta.majordomus.io'

# The CI/CD project
#oc adm new-project $CICD_PROJECT_NAME --display-name="$CICD_DISPLAY_NAME" --description='Shared CI/CD Infrastructure' --node-selector='type=user-node,zone=utility'
oc new-project $CICD_PROJECT_NAME --display-name="$CICD_DISPLAY_NAME" --description='Shared CI/CD Infrastructure'
oc project $CICD_PROJECT_NAME

# Nexus
oc new-app sonatype/nexus -n $CICD_PROJECT_NAME
oc rollout pause dc/nexus -n $CICD_PROJECT_NAME
oc expose svc/nexus
oc set probe dc/nexus --liveness --failure-threshold 3 --initial-delay-seconds 30 -- echo ok
oc set probe dc/nexus --readiness --failure-threshold 3 --initial-delay-seconds 30 --get-url=http://:8081/nexus/content/groups/public
oc volumes dc/nexus --add --name 'nexus-volume-1' --type 'pvc' --mount-path '/sonatype-work/' --claim-name 'nexus-data' --claim-size '10G' --overwrite
oc rollout resume dc/nexus -n $CICD_PROJECT_NAME

## Gogs
oc new-app -f http://bit.ly/openshift-gogs-persistent-template --param APPLICATION_NAME=gogs-$CICD_PROJECT_NAME --param HOSTNAME=gogs-$CICD_PROJECT_NAME.$DOMAIN_NAME --param GOGS_VOLUME_CAPACITY=10Gi --param DB_VOLUME_CAPACITY=10Gi --param=SKIP_TLS_VERIFY=true -n $CICD_PROJECT_NAME

# Jenkins
oc new-app jenkins-persistent --param ENABLE_OAUTH=true --param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi -n $CICD_PROJECT_NAME

