#!/bin/sh

set -u

bucket=${1}
region=${2}
endpoint=${3}

cat << EOF > policy-tmp.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicRead",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${bucket}/*"
        }
    ]
}
EOF

aws s3api put-bucket-policy --bucket ${bucket} --region ${region} --endpoint-url=${endpoint} --policy policy-tmp.json
rm policy-tmp.json