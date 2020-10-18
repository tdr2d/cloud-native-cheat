deploy:
	helm repo add jenkins https://charts.jenkins.io
	kubectl create namespace jenkins || echo "Passthrough"
	helm install jenkins jenkins/jenkins -e 