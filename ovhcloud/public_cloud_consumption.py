import ovh
import json
import pandas as pd
import os

# Instantiate. Visit https://api.ovh.com/createToken/?GET=/me
# to get your credentials
client = ovh.Client(
    endpoint='ovh-eu',
    application_key=os.getenv('OVH_application_key'),
    application_secret=os.getenv('OVH_application_secret'),
    consumer_key=os.getenv('OVH_consumer_key'),
)

def compute_total_price(json_obj):
    total = 0
    if not json_obj:
        return 0

    for family in json_obj:
        if isinstance(family, str):
            for region in json_obj[family]:
                if isinstance(region, dict):
                    total += region['totalPrice']['value'] if isinstance(region['totalPrice'], dict) else region['totalPrice'] 
        else:
            total += family['totalPrice']
    return total

if __name__ == "__main__":
    output = []
    for project in client.get('/cloud/project'):
        project_info = client.get("/cloud/project/"+project)
        if project_info['status']!='ok':
            break
        
        try:
            js = client.get("/cloud/project/"+project+"/usage/current")

            consumption = {
                'project': project_info['description'],
                'hourlyUsage': compute_total_price(js['hourlyUsage']),
                'monthlyUsage': compute_total_price(js['monthlyUsage']),
                'resourceUsage': compute_total_price(js['resourcesUsage'])
            }
            print(json.dumps(consumption, indent=2))
        except ovh.exceptions.ResourceNotFoundError:
            print(f"Resource not fount on projet {project}")
        output.append(consumption)

    pd.DataFrame(output).to_excel('public_cloud_consumption.xlsx', index=None)