import urllib.request
url = 'https://github.com/prometheus/node_exporter/releases/download/v1.1.2/sha256sums.txt'
html = urllib.request.urlopen(url).read()

# with urllib.request.urlopen(url) as response:
#    html = response.read()
#    print(html)