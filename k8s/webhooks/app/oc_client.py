import requests
import os
import urllib3
import json

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class OC:
    def __init__(self, api_url='https://openshift.redhat.com:8443'):
        debug_token = os.getenv('DEBUG_TOKEN')
        token = debug_token if debug_token else open("/var/run/secrets/kubernetes.io/serviceaccount/token").read()
        self.url = api_url
        self.header = {'Authorization': f'Bearer {token}'}

    def get_project(self, name='default'):
        url = f'{self.url}/oapi/v1/projects/{name}'
        return requests.get(url, headers=self.header, verify=False)

if __name__ == "__main__":
    oc = OC(os.getenv('API_URL'))
    r = oc.get_project('webhook')
    data = json.loads(r.text)
    # print(data)
    print(data['metadata']['labels'])