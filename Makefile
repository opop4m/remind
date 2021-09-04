
# GOPATH:=$(shell go env GOPATH)
.PHONY: buildsql
buildsql:
	flutter packages pub run build_runner build
