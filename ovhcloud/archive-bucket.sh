#!/usr/bin/bash

# From doc : https://help.ovhcloud.com/csm/en-public-cloud-storage-cold-archive-getting-started?id=kb_article_view&sysparm_article=KB0047338


# define environnement variables
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
# AWS_ENDPOINT_URL=https://s3.gra.io.cloud.ovh.net/

# Test Paris
aws s3api get-bucket-intelligent-tiering-configuration --bucket test-paris-archivage  --id myid --endpoint 'https://s3.eu-west-par.io.cloud.ovh.net'
# An error occurred (404) when calling the GetBucketIntelligentTieringConfiguration operation: Not Found

# Test RBX
aws s3api get-bucket-intelligent-tiering-configuration --bucket test-rbx-archive  --id myid --endpoint 'https://s3.rbx.io.cloud.ovh.net/'
# An error occurred (404) when calling the GetBucketIntelligentTieringConfiguration operation: Not Found

# List incomplete multipart-uploads
aws --endpoint-url https://s3.rbx-archive.io.cloud.ovh.net s3api list-multipart-uploads --bucket test-rbx-archive --endpoint 'https://s3.rbx.io.cloud.ovh.net/'

# Archive the bucket
aws --endpoint-url https://s3.rbx-archive.io.cloud.ovh.net put-ovh-archive test-rbx-archive --endpoint 'https://s3.rbx.io.cloud.ovh.net/'




# Test Cold Archive bucket 
aws --endpoint-url https://s3.rbx-archive.io.cloud.ovh.net  s3api get-bucket-intelligent-tiering-configuration --bucket testesteststestes --id myid