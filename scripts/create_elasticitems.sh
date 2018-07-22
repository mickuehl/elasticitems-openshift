#!/bin/bash

PROJECT_NAME='elasticitems'
DISPLAY_NAME='elasticitems'
DOMAIN_NAME='svc.alpha.majordomus.io'

# The elasticitems project
oc new-project $PROJECT_NAME --display-name="$DISPLAY_NAME" --description="elastic items basic deployment"
oc project $PROJECT_NAME

# Secrets
oc create -f templates/elasticitems-secrets.yaml

# Elasticsearch
oc new-app elasticsearch:1.7.5 -n elasticitems

# MongoDB
oc create -f templates/elasticitems-mongodb.yaml
