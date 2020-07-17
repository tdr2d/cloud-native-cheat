
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

auth:
	# Dex
	echo "https://github.com/dexidp/dex/blob/master/Documentation/kubernetes.md"
	echo "https://github.com/dexidp/dex/tree/master/examples"
