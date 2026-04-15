# nextcloud env
k create ns nextcloud
kns nextcloud

# Create SSE-C key for the s3_sse_c_key secretkey
openssl rand -base64 32

# Create your environment variable files
# .env-nextcloud looks like this :
username=admin
password=changeme
token=1234
s3_bucket=tdr2d
s3_sse_c_key="asdfasdf"
s3_accessKey=asdf
s3_secretKey=asdf
s3_host=s3.gra.io.cloud.ovh.net

# Create the secret
k delete secret nextcloud-env
k create secret generic nextcloud-env --from-env-file=.env-nextcloud

# helm
helm repo add nextcloud https://nextcloud.github.io/helm/
helm repo update
helm install nextcloud -f ./values.yml nextcloud/nextcloud


# Logs 
k exec -it deploy/nextcloud -- tail -f data/nextcloud.log

# Expose locally
k port-forward svc/nextcloud 8080:8080


# Test DRP
Backing up the database
1. Backup : 
2. Restore :

# S3 list files
aws s3 ls --endpoint-url=https://s3.gra.io.cloud.ovh.net s3://tdr2d

# S3 Delete files with prefix
aws s3 rm --endpoint-url=https://s3.gra.io.cloud.ovh.net s3://tdr2d --recursive --exclude "*" --include "drive*"