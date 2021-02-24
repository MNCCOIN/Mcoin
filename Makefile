# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: mcoin android ios mcoin-cross swarm evm all test clean
.PHONY: mcoin-linux mcoin-linux-386 mcoin-linux-amd64 mcoin-linux-mips64 mcoin-linux-mips64le
.PHONY: mcoin-linux-arm mcoin-linux-arm-5 mcoin-linux-arm-6 mcoin-linux-arm-7 mcoin-linux-arm64
.PHONY: mcoin-darwin mcoin-darwin-386 mcoin-darwin-amd64
.PHONY: mcoin-windows mcoin-windows-386 mcoin-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

mcoin:
	build/env.sh go run build/ci.go install ./cmd/mcoin
	@echo "Done building."
	@echo "Run \"$(GOBIN)/mcoin\" to launch mcoin."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/mcoin.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/mcoin.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

mcoin-cross: mcoin-linux mcoin-darwin mcoin-windows mcoin-android mcoin-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-*

mcoin-linux: mcoin-linux-386 mcoin-linux-amd64 mcoin-linux-arm mcoin-linux-mips64 mcoin-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-*

mcoin-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/mcoin
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep 386

mcoin-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/mcoin
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep amd64

mcoin-linux-arm: mcoin-linux-arm-5 mcoin-linux-arm-6 mcoin-linux-arm-7 mcoin-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep arm

mcoin-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/mcoin
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep arm-5

mcoin-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/mcoin
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep arm-6

mcoin-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/mcoin
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep arm-7

mcoin-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/mcoin
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep arm64

mcoin-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/mcoin
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep mips

mcoin-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/mcoin
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep mipsle

mcoin-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/mcoin
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep mips64

mcoin-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/mcoin
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-linux-* | grep mips64le

mcoin-darwin: mcoin-darwin-386 mcoin-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-darwin-*

mcoin-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/mcoin
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-darwin-* | grep 386

mcoin-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/mcoin
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-darwin-* | grep amd64

mcoin-windows: mcoin-windows-386 mcoin-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-windows-*

mcoin-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/mcoin
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-windows-* | grep 386

mcoin-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/mcoin
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/mcoin-windows-* | grep amd64
