FROM jenkins/jenkins:lts

USER root
RUN curl -LO https://get.helm.sh/helm-canary-linux-amd64.tar.gz && \
  tar -xf helm-canary-linux-amd64.tar.gz && \
  mv linux-amd64/helm /usr/local/bin/ && \
  rm -rf linux-amd64 helm-canary-linux-amd64.tar.gz

USER jenkins
RUN /usr/local/bin/install-plugins.sh kubernetes:1.25.7 workflow-job:2.39 workflow-aggregator:2.6 credentials-binding:1.23 git:4.2.2 workflow-cps:2.83
 