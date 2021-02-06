#!/bin/bash -e

cd /tmp && curl -LO https://get.helm.sh/helm-canary-linux-amd64.tar.gz && tar -xvf helm-canary* && find . -name "helm" | head -n 1 | xargs sudo cp -t /usr/local/bin && cd -