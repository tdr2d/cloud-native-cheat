#!/usr/bin/python3

from ansible.module_utils.basic import *
import pyquery
import os
import requests


# User defined functions
def get_html(url, ip):
    if os.path.exists(url):
        return open(url).read()

    # return requests.post(url, data={'ip': ip}).text # pour une requete post
    return requests.get(url).text # pour une requete get


def parse_infos(html):
    pq = pyquery.PyQuery(html)
    rows = pq('table.MsoNormalTable tr').items()
    return_dict = {}

    for i in rows:
        key = i.find('td:nth-child(1) > p').text().strip().lower().replace(' ', '_')
        value = i.find('td:nth-child(2) > p').text().strip()
        return_dict[key] = value

    return return_dict


# Usage:
# module_library:
#   ip: 1.1.1.1
#   url: google.com
if __name__ == '__main__':
    module = AnsibleModule(argument_spec=FIELDS)

    url = module.params['url']
    ip = module.params['ip']
    html = get_html(url, ip)
    vm_infos = parse_infos(html)

    module.exit_json(changed=False, meta=vm_infos)
