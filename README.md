# Openshift Deployment

## Create a Basic Authentication Secret

oc create secret generic <secret_name> \
    --from-literal=username=<user_name> \
    --from-literal=password=<password> \
    --type=kubernetes.io/basic-auth

## Reference

https://github.com/sclorg/mongodb-container
https://github.com/linkbynet/openshift-stateful-elasticsearch-cluster

https://docs.openshift.org/latest/dev_guide/builds/build_inputs.html#source-secrets-basic-authentication



oc new-app https://github.com/mickuehl/elasticitems.git#develop-v2 --source-secret=gitsecret --allow-missing-imagestream-tags=true

oc policy add-role-to-group system:image-puller system:serviceaccounts:base-images -n elasticitems
