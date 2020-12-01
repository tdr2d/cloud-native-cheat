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

python_demo:
	docker login ${REGISTRY}
	cd /tmp && git clone https://github.com/philwinder/prometheus-python
	cd /tmp/prometheus-python && docker build -t ${REGISTRY}/${REPOSITORY}/py-prometheus .
	docker push ${REGISTRY}/${REPOSITORY}/py-prometheus
	kubectl create ns test || echo
	kubectl create deployment py-prometheus -n test --image ${REGISTRY}/${REPOSITORY}/py-prometheus
	kubectl port-forward -n test deployment/py-prometheus 5000:5000

go_demo:
	kubectl create deployment go-prometheus -n test --image quay.io/brancz/prometheus-example-app:v0.2.0
	kubectl expose deployment/go-prometheus -n test --port 8080 --target-port 8080
	kubectl port-forward -n test svc/go-prometheus 8080:8080
	kubectl apply -f service-monitor.yml