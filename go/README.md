## Documentations
- install go and tools: `make install`
- proto language: 
    - https://developers.google.com/protocol-buffers/docs/proto3
    - https://developers.google.com/protocol-buffers/docs/reference/google.protobuf
- code generation: 
    - https://developers.google.com/protocol-buffers/docs/reference/go-generated#package


## Go module
- Generate go project `go mod init github.com/thomas-webber/cloud-native-cheat/go`
- Add dependencies with `go get <url>`
- Find necessary dependencies/Remove unused dependencies `go mod tidy`
- Show usage of dependencies `go why <url>`
- Clean go cached modules `go clean -cache -modcache -i -r`
- `go build` or `go run` will fetch the dependencies for you
- Show available versions `go list -m -versions go.uber.org/zap`


## Protobuf, gRPC
- binary: https://github.com/protocolbuffers/protobuf/releases, mac: `brew install protobuf`
- VScode plugins: vscode-proto3, Clang-Format
- Generate go code: `make gen`


# Go Lint https://golangci-lint.run/
- linux: https://github.com/golangci/golangci-lint/releases/download/v1.32.0/golangci-lint-1.32.0-linux-amd64.deb 
- mac: brew install golangci/tap/golangci-lint
- Simple run: `make lint` or `golangci-lint run`
- Docs: `golangci-lint help linters`