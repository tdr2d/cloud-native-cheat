# Containers
```
VMs	                                 |  Containers
Heavyweight	                         |  Lightweight
Limited performance	                 |  Native performance
Each VM runs in its own OS	         |  All containers share the host OS
Hardware-level virtualization	     |  OS virtualization
Startup time in minutes	             |  Startup time in milliseconds
Allocates required memory	         |  Requires less memory space
Fully isolated and hence more secure |  Process-level isolation, possibly less secure
```

# Kubernetes

## Controle Plane
### ETCD 
Database storing the state of the cluster
### Api server
Entry point to the etcd database
### Controller
Loop that moves the current state closer to the desired state of your objects
### Scheduler
Place the pods on the best nodes

## Nodes
### Kubelet
- Fetching logs for pods. (api to kubelet)
- Attaching (through kubectl) to running pods (api to kubelet)
### Kube proxy
Ensure connectivity between pods across nodes

## Services
### NodePort
Exposes the Service on each Node's IP at a static port 
### ClusterIP
Exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster.
### LoadBalancer
Exposes the Service externally using a cloud provider's load balancer
### ExternalName
Maps the Service to the contents of the externalName field (e.g. foo.bar.example.com), by returning a CNAME record

## CNIs
eks calico install https://www.eksworkshop.com/beginner/120_network-policies/calico/install_calico/

## Multi cluster management
https://github.com/kubesphere/kubesphere