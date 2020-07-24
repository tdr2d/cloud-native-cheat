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
parser.add_argument('--segment', help='NSX-T segment name', required=True)
args = parser.parse_args()
pw = os.getenv('NSXT_PASSWORD')
headers = {'Content-Type': 'application/json', 'X-Allow-Overwrite': 'true'}


def delete_segment(segment):
    r = requests.delete(f'https://{args.nsx_manager}/policy/api/v1/infra/segments/{segment}?force=true', headers=headers, verify=False, auth=(args.user, pw))
    print(r.url, r.text) if not r else print('DELETED', r.url)


def get_all_segment():
    r = requests.get(f'https://{args.nsx_manager}/policy/api/v1/infra/segments', headers=headers, verify=False, auth=(args.user, pw))
    data = json.loads(r.text).get('results', [])
    print(r.url, 'count:', len(data)) if r else print(r.text)
    return data


if __name__ == "__main__":
    # d = get_all_segment()
    # pprint.pprint(d)
    delete_segment(args.segment)