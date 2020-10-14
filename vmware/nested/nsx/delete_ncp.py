#!/usr/bin/python3

import requests
import sys
import json
import urllib3
import os
import argparse

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
parser = argparse.ArgumentParser()
parser.add_argument('--user', help='NSX-T User', required=True)
parser.add_argument('--nsx-manager', help='NSX-T manager ip address or domain', required=True)
parser.add_argument('--cluster', help='ncp/cluster scope tag in nsx-t', default='')
args = parser.parse_args()
pw = os.getenv('NSXT_PASSWORD')
headers = {'Content-Type': 'application/json', 'X-Allow-Overwrite': 'true'}

# usage: ./delete_ncp.py --user admin --nsx-manager 192.168.95.6 --cluster ocp4-nsx

def delete_record(endpoint=args.endpoint):
    r = requests.delete(f'https://{args.nsx_manager}/{endpoint}', headers=headers, verify=False, auth=(args.user, pw))
    print(r.url, r.text) if not r else print('DELETED', r.url)


def get_all_by_cluster(cluster):
    r = requests.get(f'https://{args.nsx_manager}/policy/api/v1/search/query?query=tags.tag:{cluster}&page_size=100', headers=headers, verify=False, auth=(args.user, pw))
    data = json.loads(r.text).get('results', [])
    print(r.url, 'count:', len(data)) if r else print(r.text)
    return data


if __name__ == "__main__":
    records = get_all_by_cluster(args.cluster)
    for item in records:
        delete_record(f'policy/api/v1{item["path"]}')