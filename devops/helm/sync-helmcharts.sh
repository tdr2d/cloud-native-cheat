#!/bin/bash -e

LOCAL_REGISTRY="$1"
LOCAL_REPO="$2"
([ -z $LOCAL_REGISTRY ] || [ -z $LOCAL_REPO ]) && printf "[ERROR] Wrong usage\nUsage: ./sync-helmcharts.sh <registry> <repo>\n" >&2 && exit 1;

# Connect to local repo
printf "Login to ${LOCAL_REGISTRY}\nUsername: " && read username
printf "Password: " && read -s password
helm repo add  --insecure-skip-tls-verify --username ${username} --password ${password} ${LOCAL_REPO} https://${LOCAL_REGISTRY}/${LOCAL_REPO}

# Sync
CHARTS=(
"prometheus-community/prometheus"
"grafana/grafana"
)
for chart in "${CHARTS[@]}"; do
  chart_repo="$(echo $chart | cut -d"/" -f1)"
  chart_name="$(echo $chart | rev | cut -d"/" -f1 | rev)"
  echo "Adding chart repo: ${chart_repo} from https://${chart_repo}.github.io/helm-charts"
  helm repo add ${chart_repo} https://${chart_repo}.github.io/helm-charts
  helm pull $chart -d /tmp
  tgz="$(ls /tmp/${chart_name}*.tgz | rev | cut -d"/" -f1 | rev)"
  curl -u${username}:${password} -k -T /tmp/${tgz} https://${LOCAL_REGISTRY}/${LOCAL_REPO}/${tgz}
  rm -f /tmp/${tgz}
done