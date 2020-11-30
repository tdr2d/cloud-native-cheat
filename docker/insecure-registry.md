On CentOS: Add field in `/etc/docker/daemon.json`

```bash
REGISTRY="hostname.cloudapp.net:5000"
cat << EOF > /etc/docker/daemon.json
{
    "insecure-registries" : [ "${REGISTRY}" ]
}
EOF

systemctl restart docker
```