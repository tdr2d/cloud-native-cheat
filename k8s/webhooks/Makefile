TAG = 0.1
IMAGE = tducrotadlere/k8s-webhook
REG = docker.io

help: 	## Show this help
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | sed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'

##
dbuild: ## Build docker image locally
	docker build -t $(IMAGE):$(TAG) .

push:	## Push docker image
	docker push $(IMAGE):$(TAG)

dev:	## Run docker container
	docker run --rm --name webhook -p 8080:8080 -e DEBUG=1 -e DEBUG_TOKEN=`oc sa get-token webhook` $(IMAGE):$(TAG)

test:	## Test the endpoint with json payloads
	curl -vX POST http://localhost:8080/mutate -d @test/test-1.json -H "Content-Type: application/json"


##
deploy: ## Deploy docker container in kubernetes
	kubectl create ns webhook
	kubectl apply -f *.yml

restart: ## Restart webhook deployment
	kubectl rollout restart deployment/mutating-webhook

update: ## Update webhook deployment
	kubectl set image deployment/mutating-webhook mutating-webhook=$(REG)/$(IMAGE):$(TAG) -n webhook
	
delete: ## Delete webhook namespace in kubernetes
	kubectl delete ns webhooks

