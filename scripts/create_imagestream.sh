#!/bin/bash

# Create the OASP project that contains the base images
oadm new-project base-images --display-name='base-images' --description='Standard Images'

oc create -f images/java/base-java-imagestream.yaml -n base-images
oc create -f images/java-mvn/java-mvn-imagestream.yaml -n base-images

oc start-build base-java -n base-images
oc start-build java-mvn -n base-images

oadm policy add-role-to-group system:image-puller system:authenticated -n base-images
