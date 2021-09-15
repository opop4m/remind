
# GOPATH:=$(shell go env GOPATH)
.PHONY: build
build:
	flutter packages pub run build_runner build
