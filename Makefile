.PHONY: help
help:
	@echo ""
	@echo ""

.PHONY: gen
gen:
	dart run build_runner build --define=envied_generator:envied=path=.env --delete-conflicting-outputs
# 	protoc --dart_out=grpc:lib/protobuf -I=. protos/v1/* google/protobuf/timestamp.proto

.PHONY: watch
watch:
	dart run build_runner watch

.PHONY: build
build:
	dart run build_runner build
	dart run build_runner build --define=envied_generator:envied=path=.env.production
