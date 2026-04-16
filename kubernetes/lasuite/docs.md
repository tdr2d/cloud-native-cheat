# Introduction
**Guide:** https://github.com/suitenumerique/docs/blob/main/docs/installation/kubernetes.md
**Architecture** https://github.com/suitenumerique/docs/blob/main/docs/architecture.md

**Caveat:**
This guide written by Suitenumerique is NOT Production ready.

**Ingress:** 
Suitenumerique suggests using Nginx Ingress Controller as a pre-requisites.
Nginx-ingress-controller is being retired, I would suggest using the modern Gateway API instead for production.

**Keycloak:**
In production Keycloak would be better installed in http mode. Https would need to be by the Gateway Class/Ingress Controller.

**Postgresql:**
The suggested postgresql deployment by suitenumerique is not production ready. It lacks redondancy, backups, logging and doesn't emmit metrics to be monitored. I advocate for using a managed databases instead, or other production ready Helm Charts like the CrunchyData operator.

**Helm charts values:**
It is not a best practice to include secrets in the values of helm charts. It is much more secured to define them using Secrets.

# Pre-requisites
- kubectl and helm cli
- A Kubernetes cluster
- A Public Domain (or Private if you have an internal DNS Server and work in a private network)
- An S3 Bucket


# Step 1 - OIDC Provider Keycloak
In the keycloak.values.yaml files, change the value according to your domain. I am using my test domain sizer.ovh with the subdomain keycloak.sizer.ovh
```yaml
  hostname: keycloak.sizer.ovh
```

```bash
helm install --repo https://suitenumerique.github.io/helm-dev-backend -f keycloak.values.yaml keycloak dev-backend
```
Then expose it using the port of choice. I will use a LoadBalancer service to have an exposed public ip.
```bash
kubectl expose svc/keycloak-dev-backend-keycloak --name keycloak-lb --port 443 --type LoadBalancer
```

Wait for the external-ip to pop, then create a DNS A recort pointing to the IP (here 145.239.55.173)
```bash
$ kubectl get svc
NAME                               TYPE           CLUSTER-IP     EXTERNAL-IP        PORT(S)         AGE
keycloak-lb                        LoadBalancer   10.3.178.205   145.239.55.173     443:30520/TCP   30s
```

# Step 2 - Redis and Postgres
```bash
helm install --repo https://suitenumerique.github.io/helm-dev-backend -f redis.values.yaml redis dev-backend
helm install --repo https://suitenumerique.github.io/helm-dev-backend -f postgresql.values.yaml postgresql dev-backend
```

Postgresql is currently bugged (from pg logs)
```
initdb: error: directory "/var/lib/postgresql/data" exists but is not empty
```
We will use a managed Postgresql Database instead : https://help.ovhcloud.com/csm/en-ie-public-cloud-databases-getting-started?id=kb_article_view&sysparm_article=KB0048743
Make sure the database is exposed to the kubernetes cluster nodes. You can open the traffic to all the private vlan 10.0.0.0/16.

# Step 3 - S3 Object Storage 
I will use a managed S3 solution by OVHCloud.
https://help.ovhcloud.com/csm/en-ie-public-cloud-storage-s3-getting-started-object-storage?id=kb_article_view&sysparm_article=KB0047339


# Step 4 - Impress Backend
Fix the values in impress.values.yaml, change keycloak.sizer.ovh by your subdomain.
```yaml
# Keycloak
OIDC_OP_JWKS_ENDPOINT: https://keycloak.sizer.ovh/realms/impress/protocol/openid-connect/certs
OIDC_OP_AUTHORIZATION_ENDPOINT: https://keycloak.sizer.ovh/realms/impress/protocol/openid-connect/auth
OIDC_OP_TOKEN_ENDPOINT: https://keycloak.sizer.ovh/realms/impress/protocol/openid-connect/token
OIDC_OP_USER_ENDPOINT: https://keycloak.sizer.ovh/realms/impress/protocol/openid-connect/userinfo
OIDC_OP_LOGOUT_ENDPOINT: https://keycloak.sizer.ovh/realms/impress/protocol/openid-connect/logout
OIDC_RP_CLIENT_ID: impress
OIDC_RP_CLIENT_SECRET: ThisIsAnExampleKeyForDevPurposeOnly
OIDC_RP_SIGN_ALGO: RS256
OIDC_RP_SCOPES: "openid email"

# S3 vars example
AWS_S3_ENDPOINT_URL: https://s3.gra.io.cloud.ovh.net
AWS_S3_ACCESS_KEY_ID: FIXME
AWS_S3_SECRET_ACCESS_KEY: FIXME
AWS_STORAGE_BUCKET_NAME: lasuite-test2

...

serviceMedia:
  host: https://s3.gra.io.cloud.ovh.net/
  port: 443
```

Then install the helm package
```bash
helm repo add impress https://suitenumerique.github.io/docs/
helm repo update
helm install impress impress/docs -f impress.values.yaml

kubectl get pods
NAME                                          READY   STATUS              RESTARTS        AGE
impress-docs-backend-58b899fb59-bf848         0/1     ContainerCreating   0               8m27s
impress-docs-backend-createsuperuser-m2psx    0/1     ContainerCreating   0               8m27s
impress-docs-backend-migrate-8pxfv            0/1     ContainerCreating   0               8m27s
impress-docs-celery-worker-5cfb78c994-dlq4h   0/1     ContainerCreating   0               8m27s
impress-docs-frontend-7f985d74c9-nhj7l        1/1     Running             0               8m27s
impress-docs-y-provider-655bcff5bd-tmkzz      1/1     Running             0               8m27s
keycloak-dev-backend-keycloak-0               1/1     Running             1 (88m ago)     88m
keycloak-dev-backend-keycloak-pg-0            1/1     Running             0               88m
postgresql-dev-backend-postgres-0             0/1     CrashLoopBackOff    18 (3m2s ago)   71m
redis-dev-backend-redis-68c44c659f-hzgbg      1/1     Running             0               6h42m
```

Impress pods are stuck at ContainerCreating

