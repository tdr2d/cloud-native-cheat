import re

data = """
Hudson-Version: 2.222.1
Jenkins-Version: 2.222.1
Plugin-Dependencies: workflow-api:2.40,workflow-cps:2.80;resolution:=o
 ptional,workflow-step-api:2.22,authentication-tokens:1.3,cloudbees-fo
 lder:6.12,credentials:2.3.5,durable-task:1.34,jackson2-api:2.10.3,kub
 ernetes-client-api:4.9.1-1,plain-credentials:1.6,structs:1.20,variant
 :1.3,kubernetes-credentials:0.6.2,pipeline-model-extensions:1.6.0;res
 olution:=optional
Plugin-Developers: Carlos Sanchez:carlos:carlos@apache.org
Plugin-License-Name: Apache License 2.0
Plugin-License-Url: https://www.apache.org/licenses/LICENSE-2.0
Plugin-ScmUrl: https://github.com/jenkinsci/kubernetes-plugin
"""

def get_indented_content_by_key(key):
  return re.compile(f'^{key}: ([\s\S]+?)[A-Z]', re.MULTILINE)

match = re.findall(get_indented_content_by_key('Plugin-Dependencies'), data)
print(match[0].replace(' ', '').replace('\n','').split(','))