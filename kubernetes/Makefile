
get_helm:
	curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

deployments:
	kubectl rollout history deployment/app
	kubectl rollout undo deployment/app --to-revision=2 --record

autoscale:
	kubectl autoscale rs foo --min=2 --max=5 --cpu-percent=80

conformance:
	sonobuoy run --mode quick --wait
	sonobuoy results $(sonobuoy retrieve)
	sonobuoy delete --wait

	# sonobuoy status
	# sonobuoy logs
	# sonobuoy gen --e2e-focus="sig-networking" --e2e-skip="Alpha" | kubectl apply -f -

multitenancy-e2e:
	git clone https://github.com/kubernetes-sigs/multi-tenancy.git
	cd multi-tenancy/benchmarks
	# update config.yaml with your cluster configuration.
	go test ./e2e/tests


auth:
	# Dex
	echo "https://github.com/dexidp/dex/blob/master/Documentation/kubernetes.md"
	echo "https://github.com/dexidp/dex/tree/master/examples"


registry_access_per_namespace:
	oc create secret docker-registry artifactory-secret \
		--docker-server=<registry> \
		--docker-username=<username> \
		--docker-password=<password>

	oc secrets link default artifactory-secret --for=pull