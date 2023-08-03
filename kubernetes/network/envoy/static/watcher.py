from kubernetes import client, config

# Configs can be set in Configuration class directly or using helper utility
config.load_kube_config()

def get_node_internal_ips():
    node_internal_ips = []
    nodes = client.CoreV1Api().list_node(watch=False)
    for node in nodes.items:
        node = node.to_dict()
        node_internal_ips.append(next(filter(lambda x: x['type'] == 'InternalIP', node['status']['addresses']))['address'])
    return node_internal_ips

def get_service_node_ports():
    node_ports = []
    services = client.CoreV1Api().list_service_for_all_namespaces(watch=False)
    for svc in services.items:
        svc = svc.to_dict()
        # print(svc['spec']['ports'])
        node_ports.append(next(filter(lambda x: 'node_port' in x, svc['spec']['ports']), None)['node_port'])
    return list(filter(None, node_ports))

def write_envoy_eds_endpoints(k8s_nodes, k8s_ports):
    
    pass

print(get_node_internal_ips())
print(get_service_node_ports())