# Requirements
- openstack api credentials
- Existing private network
- Existing floating-ip


## Additional doc
https://github.com/kubernetes/cloud-provider-openstack/blob/master/docs/octavia-ingress-controller/using-octavia-ingress-controller.md


```sh
# Get project ID
openstack project list
openstack project show [project-id]

# Get network id
openstack network list
openstack network show [net-id]

# Get floating ip
openstack floating ip list
openstack floating ip show [f-id]
os loadbalancer flavor list # to list flavor ids

# Create config secret  
k create secret generic ingress-openstack-conf --from-file=octavia-ingress-controller-config.yaml=.ingress_openstack
```
```yaml
# .ingress_openstack config looks like this
cluster-name: ${cluster_name}  # name of k8s cluster
openstack:
  auth-url: ${auth_url}
  domain-name: ${domain-name}
  username: ${user_name}
  # user-id: ${user_id}
  password: ${password}
  project-id: ${project_id}
  region: ${region}
octavia:
  provider: amphora # Make sure you use amphora
  flavor-id: ${favor_id}
  manage-security-groups: true
  subnet-id: ${subnet_id} # name of subnet id 
  floating-network-id: ${public_net_id} # a floating ip must exists name of floating_network_id


# Mount secret in pod
```yaml
In .spec.template.spec.volumes def
volumes:
  - name: ingress-openstack-conf
    secret:
      secretName: ingress-openstack-conf

# In .spec.template.spec.containers def
args:
- /bin/octavia-ingress-controller
- --config=/etc/config/octavia-ingress-controller-config.yaml
volumeMounts:
- name: ingress-openstack-conf
  mountPath: /etc/config/
  readOnly: true
```
```sh
# Deploy
k apply -f 2-deployment.yaml
k logs -l app=octavia-ingress-controller

# Deploy nginx example Deployment + NodePort Service + Ingress
k apply -f 3-demo-nginx.yaml


# Test
os loadbalancer list
curl VIP_ADDRESS:80  # must return nginx welcom message
```


