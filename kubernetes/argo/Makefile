# DOC https://argoproj.github.io/argo/

argo_cli:
	cd /tmp && curl -LO https://github.com/argoproj/argo/releases/download/v2.11.8/argo-linux-amd64.gz
	gunzip /tmp/argo-linux-amd64.gz
	chmod +x /tmp/argo-linux-amd64
	sudo mv /tmp/argo-linux-amd64 /usr/local/bin/argo
	argo version

deps:
	helm repo add argo https://argoproj.github.io/argo-helm
	kubectl create ns argo
	oc adm policy add-scc-to-user anyuid -z default -n argo
	helm search repo

deploy:
	#helm upgrade --install argo argo/argo -f values.yml -n argo # Charts is BUGGY https://github.com/argoproj/argo-helm/issues/455
	kubectl apply -n argo -f quickstart.yml
	#oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:argo:default

expose:
	oc create route edge --service argo-server -n argo

examples:
	# https://argoproj.github.io/argo/examples/
