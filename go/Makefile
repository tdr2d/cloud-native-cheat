.PHONY: plugins grpc

help: 
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | gsed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'

install:	## Install Go
	cd /tmp && curl -L -o go.tar.gz https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
	sudo tar -zxf /tmp/go.tar.gz -C /usr/local/
	sudo ln -s /usr/local/go/bin/go /usr/local/bin/go 
	sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt 
	go get -u github.com/golang/protobuf/{proto,protoc-gen-go} # grpc stuffs
	go get -u google.golang.org/grpc
	cd /tmp && curl -Lo buf "https://github.com/bufbuild/buf/releases/download/v0.28.0/buf-$$(uname)-x86_64" && chmod +x buf && sudo mv buf /usr/local/bin # buf

##
## Tests
lint:	## Lint golang code
	golangci-lint run
test: 	## Run *_test.go files 
	go test
coverage: ## Run test with code coverage
	$$(go env GOPATH)/bin/gocov test

##
## Plugins
plugins:
	cd plugins/quick_sort && go build -buildmode=plugin -o ../quick_sort_plugin.so
	cd plugins/bubble_sort && go build -buildmode=plugin -o ../bubble_sort_plugin.so
test_plugins:
	cd plugins_test && go build -o a.out
	./plugins_test/a.out
clean_plugins:
	cd plugins && rm -rf *.so && rm -f a.out

##
## Protobuf
buf_lint:	## Lint proto files
	buf check lint

gen: ## Generate protobuf code
	for out in .; do \
	protoc --go_out=$$out --go_opt=paths=source_relative --go-grpc_out=$$out --go-grpc_opt=paths=source_relative pb/*.proto; \
	done

clean:  ## Remove **pb.go
	rm $$(find . -name "*pb.go" | tee /dev/tty)