import base64
import copy
import http
import json
import os
import logging
import jsonpatch
from flask import Flask, jsonify, request
from oc_client import OC
from contants import *

app = Flask(__name__)
oc = OC(os.getenv('API_URL'))

## TODO
# @app.route("/validate", methods=["POST"])
# def validate():
#     allowed = True
#     try:
#         for container_spec in request.json["request"]["object"]["spec"]["containers"]:
#             if "env" in container_spec:
#                 allowed = False
#     except KeyError:
#         pass
#     return jsonify(
#         {
#             "response": {
#                 "allowed": allowed,
#                 "uid": request.json["request"]["uid"],
#                 "status": {"message": "env keys are prohibited"},
#             }
#         }
#     )


@app.route("/mutate", methods=["POST"])
def mutate():
    spec = request.json["request"]["object"]
    modified_spec = copy.deepcopy(spec)

    try:
        for key in list(LABELS.keys()):
            value = LABELS[key](spec)
            modified_spec["metadata"]["labels"][key] = value
        
        namespace = spec["metadata"]["namespace"]
        print(f'Object\'s namespace is {namespace}')
        r = oc.get_project(namespace)
        if r:
            labels = json.loads(r.text)['metadata']['labels']
            modified_spec["metadata"]["labels"]['nsx.env'] = labels['environment']
            modified_spec["metadata"]["labels"]['nsx.app'] = labels['iua']
    except KeyError:
        pass
    patch = jsonpatch.JsonPatch.from_diff(spec, modified_spec)
    
    return jsonify(
        {
            "response": {
                "allowed": True,
                "uid": request.json["request"]["uid"],
                "patch": base64.b64encode(str(patch).encode()).decode(),
                "status": {"message": "test message"},
                "patchtype": "JSONPatch",
            }
        }
    )


if __name__ == "__main__":
    if os.getenv('DEBUG'):
        app.run(host="0.0.0.0", port=8080)
    else:
        print("Running on port 8443")
        app.run(host="0.0.0.0", port=8443, ssl_context=("/etc/secret-volume/tls.crt", "/etc/secret-volume/tls.key"))