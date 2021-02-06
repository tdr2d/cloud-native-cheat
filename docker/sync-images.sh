#!/bin/bash -e

LOCAL_REGISTRY="$1"
LOCAL_REPO="$2"
([ -z $LOCAL_REGISTRY ] || [ -z $LOCAL_REPO ]) && printf "[ERROR] Wrong usage\nUsage: ./sync-image.sh <registry> <repo>\n" >&2 && exit 1;
IMAGES=(
"quay.io/prometheus/alertmanager:v0.21.0"
"quay.io/prometheus/node-exporter:v1.0.1"
"quay.io/prometheus/prometheus:v2.22.1"
"docker.io/prom/pushgateway:v1.3.0"
"docker.io/grafana/grafana:7.3.3"
"quay.io/coreos/kube-state-metrics/v1.9.7"
)

for img in "${IMAGES[@]}"; do
  image_name=$(echo $img | rev | cut -d"/" -f1 | rev)
  docker pull $img
  docker tag $img $LOCAL_REGISTRY/$LOCAL_REPO/$image_name
  docker push $LOCAL_REGISTRY/$LOCAL_REPO/$image_name
done