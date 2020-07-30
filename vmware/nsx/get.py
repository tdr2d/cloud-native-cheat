#!/usr/bin/python3

import requests
import sys
import json
import urllib3
import os
import argparse
import pprint

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
parser = argparse.ArgumentParser()
parser.add_argument('--user', help='NSX-T User', required=True)
parser.add_argument('--nsx-manager', help='NSX-T manager ip address or domain', required=True)
parser.add_argument('--endpoint', help='Endpoint https://code.vmware.com/apis/976/nsx-t', required=True)
args = parser.parse_args()
pw = os.getenv('NSXT_PASSWORD')
headers = {'Content-Type': 'application/json', 'X-Allow-Overwrite': 'true'}

# Get endpoint here https://code.vmware.com/apis/976/nsx-t
# usage: ./get.py --user admin --nsx-manager 192.168.145.80 --endpoint "/policy/api/v1/infra/ip-pools"

def get():
    r = requests.get(f'https://{args.nsx_manager}/{args.endpoint.strip("/")}', headers=headers, verify=False, auth=(args.user, pw))
    data = json.loads(r.text).get('results', [])
    print(r.url, 'count:', len(data)) if r else print(r.text)
    return data if data else json.loads(r.text)


if __name__ == "__main__":
    d = get()
    pprint.pprint(d)