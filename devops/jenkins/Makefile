help: 
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | sed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'


## Scripts
deps:		## Install ansible dependancies
	sudo pip install python-jenkins
	ansible-galaxy collection install community.general

sync: ## sync
	scp -r . root@192.168.95.150:/root/jenkins

get_password: ## Get initial jenkins password
	ssh root@192.168.95.150 'docker exec -t jenkins "cat" "/var/jenkins_home/secrets/initialAdminPassword"'

docker: ## Build and run jenkins in background
	docker build -t my-jenkins:v1 .
	docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -e JAVA_OPTS="-Dpermissive-script-security.enabled=true" my-jenkins:v1
	docker logs -f jenkins

clean: ## Stop jenkins container and clean all related files
	docker stop jenkins
	docker rm jenkins
	docker volume rm jenkins_home

##
## Ansible playbooks
configure_jenkins: ## Configure jenkins with ansible
	ansible-playbook playbooks/configure_jenkins.yml

job: ## Launch jenkins job
	ansible-playbook playbooks/job.yml
