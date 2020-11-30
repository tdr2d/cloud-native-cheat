sync: 
	rsync -azP ./ root@192.168.95.150:~/test

add_repos:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stable https://charts.helm.sh/stable # for kube-state-metrics
	helm repo update

deploy:
	kubectl create ns monitoring || echo "Passthrough"
	helm upgrade --install -n monitoring prometheus prometheus-community/prometheus -f prometheus-values.yml
	oc create route edge --service prometheus-server -n monitoring

clean:
	oc delete route -n monitoring prometheus-server
	helm delete prometheus