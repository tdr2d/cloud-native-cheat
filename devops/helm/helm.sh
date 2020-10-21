#!/bin/bash

set -euo pipefail
# set -x

# Env
# export ARTIFACTORY_URL="https://repo.artifactory.priv:443"
# export ARTIFACTORY_USER="admin"
# export ARTIFACTORY_PASSWORD="****"

readonly repo_key="helm_demo"
readonly repo_url="${ARTIFACTORY_URL}/artifactory/${repo_key}"
readonly chart_name="my-nginx"
readonly chart_version="0.0.1"
readonly namespace=default

## Usage ./helm.sh options
##
## help: show this helps
help() { cat $0 | fgrep -h "##" | fgrep -v "fgrep" | column -s: -t | sed -e 's/## //' | sed -e 's/##//'; }


## create: Generate helm charts
create() {
  helm create ${chart_name} # generate default charts
  cd ${chart_name} && rm -rf templates/* && echo 'image: nginx' > values.yaml # only keep the minimum
  kubectl create deployment ${chart_name} --image="{{ .Values.image }}" --dry-run -o yaml > templates/deployment.yaml # generate deployment
  helm lint .
  cd - && helm package ${chart_name} --version ${chart_version} --destination /tmp
}


## artifactory: Operations on artifactory
artifactory() {
  # Create: Admin -> Repositories:Local -> new:type=helm
  # Setup: Home -> helm_demo -> deploy

  ## push: Push package
  push() {
    curl -u${ARTIFACTORY_USER}:${ARTIFACTORY_PASSWORD} -k \
      -T /tmp/${chart_name}-${chart_version}.tgz \
      "${repo_url}/${chart_name}-${chart_version}.tgz"  # If api_key, use -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}"
  }

  ## configure: Configure helm
  configure() {
    helm repo add ${repo_key} ${repo_url} --username ${ARTIFACTORY_USER} --password ${ARTIFACTORY_PASSWORD} --insecure-skip-tls-verify
    helm repo update
  }
  $*
}


## deploy: deploy helm chart to kubernetes
deploy() {
  helm --debug install ${chart_name} ${repo_url}/${chart_name}-${chart_version}.tgz \
    --set image=nginx --insecure-skip-tls-verify -n ${namespace}
  watch kubectl get pods -n default
  helm list
}

## check_deployed: check if release exists and is deployed
# TODO check if deployment exists on the cluster
check_deployed() {
  if helm list --short --deployed | grep -q ${chart_name}; then
    echo "${chart_name} exists"
  else
    echo "${chart_name} don't exists"
  fi
}

## update: update chart release
update() {
  helm upgrade ${chart_name} ${repo_url}/${chart_name}-${chart_version}.tgz \
    --set image=apache --insecure-skip-tls-verify -n ${namespace}
}

## delete: delete app running on kubernetes
delete() {
  helm uninstall ${chart_name}
}

$*