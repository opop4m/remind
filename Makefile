
# GOPATH:=$(shell go env GOPATH)
.PHONY: build
build:
	flutter packages pub run build_runner build


.PHONY: native
native:
	flutter run --release -d $(d)

.PHONY: web
web:
	flutter run -d web-server --web-renderer html
	
.PHONY: buildapk
buildapk:
	flutter build apk --target-platform android-arm64 --split-per-abi

.PHONY: emulator
emulator:
	/Users/john/Library/Android/sdk/emulator/emulator -avd Nexus_4_API_30 -netdelay none -netspeed full

.PHONY: testdart
testdart:
	dart --packages=.packages --enable-asserts package:client/test/test.dart