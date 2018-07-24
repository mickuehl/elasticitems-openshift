# Openshift Deployment

## Create the Java imagestream

    ./scripts/create_imagestream.sh

## Create a new project

    export PROJECT_NAME='elasticitems'
    export DISPLAY_NAME='elasticitems'
    
    # The elasticitems project
    oc new-project $PROJECT_NAME --display-name="$DISPLAY_NAME" --description="elastic items basic deployment"
    oc project $PROJECT_NAME


### Create Basic Authentication Secret

    oc create secret generic <secret_name> \
        --from-literal=username=<user_name> \
        --from-literal=password=<password> \
        --type=kubernetes.io/basic-auth \
        -n <project>

where `secret_name` is `gitsecret` and `user_name` and `password` are your GitHub credentials. Add the git credentials to
project `elasticitems`.

### Add the project secrets

    oc create -f templates/elasticitems-secrets.yaml

### Deploy ElasticSearch from a Docker Container

    oc new-app elasticsearch:1.7.5 -n elasticitems

### Deploy MongoDB with a Deployment Configuration

Deploy MongoDB from a built-in template:

    oc create -f templates/elasticitems-mongodb.yaml
    
### Create the Dataloader Container

Deploy the build configuration:

    oc create -f templates/elasticitems-mongodb-loader.yaml

and manually trigger the build:

    oc start-build mongodb-loader -n elasticitems


### Build the App

    oc create -f templates/elasticitems-build.yaml

### Deploy the App

    oc create -f templates/elasticitems-deploy.yaml


## Reference

* https://github.com/sclorg/mongodb-container
* https://docs.openshift.org/latest/using_images/db_images/mongodb.html
* https://github.com/linkbynet/openshift-stateful-elasticsearch-cluster 
* https://docs.openshift.org/latest/dev_guide/builds/build_inputs.html#source-secrets-basic-authentication 
* https://portworx.com/ha-mongodb-kubernetes/
