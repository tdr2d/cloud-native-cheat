.PHONY: plugins grpc

install:
	cd /tmp && curl -L -o go.tar.gz https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
	sudo tar -zxf /tmp/go.tar.gz -C /usr/local/
	sudo ln -s /usr/local/go/bin/go /usr/local/bin/go 
	sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt 


### PLUGINS
plugins:
	test -f plugins/quick_sort_plugin.so || (cd plugins/quick_sort && go build -buildmode=plugin -o ../quick_sort_plugin.so)
	test -f plugins/bubble_sort_plugin.so || (cd plugins/bubble_sort && go build -buildmode=plugin -o ../bubble_sort_plugin.so)

test_plugins:
	cd plugins_test && go build -o a.out
	./plugins_test/a.out

clean_plugins:
	cd plugins && rm -rf *.so && rm -f a.out


### GRPC
init_pb:
	go install google.golang.org/protobuf/cmd/protoc-gen-go
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc

genpb:
	protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative pb/*.proto