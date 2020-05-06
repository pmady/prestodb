#!/bin/bash

set -e

REPONAME=pmady7389
PRESTOVERSION=333

#docker build --build-arg PRESTO_VERSION=$PRESTOVERSION -t prestosql .

# Tag and push to the public docker repository.
#docker tag fb-presto $REPONAME/prestosql
#docker push $REPONAME/prestosql

# Update configMap in Kubernetes
kubectl create namespace pavan
kubectl config set-context --current --namespace=pavan
kubectl create configmap presto-cfg --dry-run --from-file=config.properties.coordinator --from-file=config.properties.worker --from-file=node.properties.template --namespace=pavan -o yaml | kubectl apply -f -
kubectl apply -f presto.yaml
