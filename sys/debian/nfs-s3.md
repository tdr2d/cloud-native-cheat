
# Needed Packages
```sh
sudo apt-get install s3fs -y
```

# s3-fs
```sh
# s3fs recognizes the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_SESSION_TOKEN environment variables.
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'

echo "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" > ~/.passwd-s3fs
chmod 600 ~/.passwd-s3fs
sudo mkdir /mnt/s3drive
sudo chown -R ${USER} /mnt/s3drive

# Test S3 connectivity
# remove -f argument to let the logs are at /var/log/messages
s3fs tdr2d /mnt/s3drive -o passwd_file=${HOME}/.passwd-s3fs -o dbglevel=info -o url=https://s3.gra.io.cloud.ovh.net -o endpoint=gra -f

echo 'hello world!' > /mnt/s3-drive/test.html

# Check S3 objects
aws s3 --endpoint-url https://s3.gra.io.cloud.ovh.net/ --region gra ls s3://tdr2d

# Reboot proof, add line in /etc/fstab
# s3fs#tdr2d /mnt/s3drive fuse.s3fs _netdev,passwd_file=/home/debian/.passwd-s3fs,url=https://s3.gra.io.cloud.ovh.net 0 0
```


# Benchmark
https://medium.com/@maksym.lutskyi/a-comparative-analysis-of-mountpoint-for-s3-s3fs-and-goofys-9a097a25